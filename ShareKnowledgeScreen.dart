import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ShareKnowledgeScreen extends StatefulWidget {
  const ShareKnowledgeScreen({super.key});

  @override
  _ShareKnowledgeScreenState createState() => _ShareKnowledgeScreenState();
}

class _ShareKnowledgeScreenState extends State<ShareKnowledgeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tipsController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitKnowledge() {
    final String title = _titleController.text;
    final String tips = _tipsController.text;

    if (title.isNotEmpty && tips.isNotEmpty) {
      // Handle the form submission logic here
      // For example, you can send this data to a server or save it locally
      print('Title: $title');
      print('Tips: $tips');
      if (_image != null) {
        print('Image path: ${_image!.path}');
      }

      // Clear the input fields
      _titleController.clear();
      _tipsController.clear();
      setState(() {
        _image = null;
      });

      // Show a success message and navigate to ViewShareKnowledgeScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge shared successfully!')),
      );

      // Navigate to ViewShareKnowledgeScreen
      Navigator.pushNamed(context, '/viewShareKnowledge');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Knowledge'),
        backgroundColor:
            const Color(0xFF87CEEB), // Custom green color for farmers app
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box), // Use an icon for navigation
            onPressed: () {
              Navigator.pushNamed(
                  context, '/uploadProduct'); // Navigate to ProductUploadScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Color(0xFF87CEEB)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF87CEEB), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF87CEEB), width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _tipsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Tips',
                labelStyle: const TextStyle(color: Color(0xFF87CEEB)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF87CEEB), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF87CEEB), width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF87CEEB), // Set button color
                  ),
                  child: const Text('Pick an Image'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitKnowledge,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87CEEB), // Set button color
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
