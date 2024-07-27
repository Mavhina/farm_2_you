import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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

  // Function to get the message
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
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMDk3OTg0LCJleHAiOjE3MjIwOTk3ODR9.WU7VTvzIBoQP-zjpMcUFat4636ZDnOWuvTq4ldv3xn0" // The Bearer token
        },
      );

      if (response.statusCode == 201) {
        final List<dynamic> messages = json.decode(response.body);
        setState(() {
          _messages.clear();
          for (var message in messages) {
            _messages.add({
              'text': message['message']['text'],
              'image': null,
            });
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
    print('Image uploaded successfully');
    const url = 'https://api.ayoba.me/v1/business/message/media/get-slots';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll({
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMDk3OTg0LCJleHAiOjE3MjIwOTk3ODR9.WU7VTvzIBoQP-zjpMcUFat4636ZDnOWuvTq4ldv3xn0" // The Bearer token
        })
        ..files.add(await http.MultipartFile.fromPath('file', image.path))
        ..fields['fileNames'] =
            json.encode(['${DateTime.now().millisecondsSinceEpoch}.jpg']);

      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        // Optionally, handle success, e.g., update UI or notify user
      } else {
        print('Failed to upload image: ${response.statusCode}');
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
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImMwZmI2Y2Y2MWQyZDVjMDc4NGE2NGFmMzAxMTk4YTdkNzJhMDFhZDkiLCJqaWQiOiJjMGZiNmNmNjFkMmQ1YzA3ODRhNjRhZjMwMTE5OGE3ZDcyYTAxYWQ5QGF5b2JhLm1lIiwiZ3JvdXAiOiJidXNpbmVzcyIsIm1zaXNkbiI6bnVsbCwiaWF0IjoxNzIyMDk3OTg0LCJleHAiOjE3MjIwOTk3ODR9.WU7VTvzIBoQP-zjpMcUFat4636ZDnOWuvTq4ldv3xn0" // Bearer token
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        setState(() {
          _messages.add({'text': text, 'image': null});
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
          _messages.add({'text': null, 'image': _image});
        }
      });
    }
  }

  void _navigateToShareKnowledge() {
    Navigator.pushNamed(context, '/shareKnowledge');
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
                return _messages[index]['text'] != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(_messages[index]['text']),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.file(_messages[index]['image']),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions,
                              color: Color(0xFF87CEEB)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file,
                              color: Color(0xFF87CEEB)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF87CEEB)),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
