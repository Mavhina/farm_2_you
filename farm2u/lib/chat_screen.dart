import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  File? _image;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFetchingMessages();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startFetchingMessages() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    const url = 'https://api.ayoba.me/v1/business/message';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMTcwMzAyLCJleHAiOjE3MjIxNzIxMDJ9.7cqouZ2CZnZWAGLm1ErTZ6pGgmQRb5iSME778XjvIvE",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> messages = json.decode(response.body);
        setState(() {
          for (var message in messages) {
            if (message['message'] != null &&
                message['message']['text'] != null) {
              _messages.add({
                'text': message['message']['text'],
                'image': null,
                'isSent': false,
              });
            }
          }
        });
      } else {
        print('Failed to fetch messages: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _uploadImage(File image) async {
    const url = 'https://api.ayoba.me/v1/business/message/media/get-slots';
    try {
      final fileName = basename(image.path);

      final requestBody = json.encode({
        'fileNames': [fileName]
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMTcwMzAyLCJleHAiOjE3MjIxNzIxMDJ9.7cqouZ2CZnZWAGLm1ErTZ6pGgmQRb5iSME778XjvIvE',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final List<dynamic> slots = responseBody['slots'];

        print('Image name: $fileName');

        for (var slot in slots) {
          final postUrl = slot['postUrl'];
          final getUrl = slot['getUrl'];
          final key = slot['key'];
          final contentType = slot['contentType'];
          final xAmzAlgorithm = slot['xAmzAlgorithm'];
          final xAmzCredential = slot['xAmzCredential'];
          final xAmzDate = slot['xAmzDate'];
          final xAmzSecurityToken = slot['xAmzSecurityToken'];
          final policy = slot['policy'];
          final xAmzSignature = slot['xAmzSignature'];

          print('Post URL: $postUrl');
          print('Get URL: $getUrl');
          print('Key: $key');
          print('Content Type: $contentType');
          print('xAmzAlgorithm: $xAmzAlgorithm');
          print('xAmzCredential: $xAmzCredential');
          print('xAmzDate: $xAmzDate');
          print('xAmzSecurityToken: $xAmzSecurityToken');
          print('Policy: $policy');
          print('xAmzSignature: $xAmzSignature');

          // Upload file to the postUrl
          await _uploadFileToS3(
            postUrl,
            image,
            key,
            contentType,
            xAmzAlgorithm,
            xAmzCredential,
            xAmzDate,
            xAmzSecurityToken,
            policy,
            xAmzSignature,
          );

          // Send message with the image URL
          final messagePayload = {
            "msisdns": ["+27606125350"],
            "message": {
              "url": getUrl,
              "caption": "check this out",
              "type": "media",
              "blurhush": "",
              "height": "200",
              "width": "300",
            }
          };

          await _sendMessageWithMedia(messagePayload);
        }
      } else {
        print('Failed to get slots: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _uploadFileToS3(
      String postUrl,
      File image,
      String key,
      String contentType,
      String xAmzAlgorithm,
      String xAmzCredential,
      String xAmzDate,
      String xAmzSecurityToken,
      String policy,
      String xAmzSignature) async {
    try {
      final uri = Uri.parse(postUrl);

      print('URI: $uri');
      print('Key: $key');

      // Create a multipart request
      final request = http.MultipartRequest('POST', uri)
        ..fields['key'] = key
        ..fields['Content-Type'] = contentType
        ..fields['x-amz-algorithm'] = xAmzAlgorithm
        ..fields['x-amz-credential'] = xAmzCredential
        ..fields['x-amz-date'] = xAmzDate
        ..fields['x-amz-security-token'] = xAmzSecurityToken
        ..fields['policy'] = policy
        ..fields['x-amz-signature'] = xAmzSignature
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: key,
        ));

      // Send the request
      final response = await request.send();

      // Check the response
      if (response.statusCode == 204) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _sendMessageWithMedia(
      Map<String, dynamic> messagePayload) async {
    const url = 'https://api.ayoba.me/v1/business/message';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMTcwMzAyLCJleHAiOjE3MjIxNzIxMDJ9.7cqouZ2CZnZWAGLm1ErTZ6pGgmQRb5iSME778XjvIvE",
        },
        body: json.encode(messagePayload),
      );

      if (response.statusCode == 201) {
        setState(() {
          _messages.add({'text': null, 'image': _image, 'isSent': true});
        });
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    const url = 'https://api.ayoba.me/v1/business/message';

    final payload = {
      "msisdns": ["+27606125350"],
      "message": {
        "type": "text",
        "text": text,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMTUwOTU0LCJleHAiOjE3MjIxNTI3NTR9.TZPaxlyKh-4o814rSZehp3x9EbsWaRRhANBksYG66qA",
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        setState(() {
          _messages.add({'text': text, 'image': null, 'isSent': true});
        });
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }

    _controller.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        if (_image != null) {
          _uploadImage(_image!);
        }
      });
    }
  }

  void _navigateToShareKnowledge() {
    //Navigator.pushNamed(context, '/shareKnowledge');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text('Chat'),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToShareKnowledge,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final isSent = _messages[index]['isSent'];
                return Align(
                  alignment:
                  isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.lightBlueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _messages[index]['text'] != null
                        ? Text(_messages[index]['text'])
                        : Image.file(_messages[index]['image']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, color: Color(0xFF87CEEB)),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF87CEEB)),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}