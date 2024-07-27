import 'package:flutter/material.dart';

class ReadMoreScreen extends StatelessWidget {
  final Map<String, String> knowledgeItem;

  const ReadMoreScreen({Key? key, required this.knowledgeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(knowledgeItem['title']!),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              knowledgeItem['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              knowledgeItem['title']!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            Text(
              knowledgeItem['description']!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              'More Information about ${knowledgeItem['title']} will be displayed here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
