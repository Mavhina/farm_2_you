import 'package:flutter/material.dart';
import 'ReadMoreScreen.dart';

class ViewShareKnowledgeScreen extends StatelessWidget {
  final List<Map<String, String>> knowledgeItems = [
    {
      'image': 'assets/images/bag_1.png',
      'title': 'Innovative Farming Techniques',
      'description':
          'Explore the latest techniques in farming that can boost productivity and sustainability.'
    },
    {
      'image': 'assets/images/bag_2.png',
      'title': 'Modern Irrigation Systems',
      'description':
          'Learn about advanced irrigation systems designed to conserve water and maximize crop yield.'
    },
    {
      'image': 'assets/images/bag_3.png',
      'title': 'Organic Pest Control',
      'description':
          'Discover natural methods to control pests and maintain a healthy farm ecosystem.'
    },
    {
      'image': 'assets/images/bag_4.png',
      'title': 'Sustainable Soil Management',
      'description':
          'Understand the best practices for managing soil health and fertility to ensure long-term productivity.'
    },
    {
      'image': 'assets/images/bag_5.png',
      'title': 'Advanced Crop Genetics',
      'description':
          'Get insights into the latest advancements in crop genetics and their impact on yield and resilience.'
    },
    {
      'image': 'assets/images/bag_6.png',
      'title': 'Efficient Farm Machinery',
      'description':
          'Explore the newest farm machinery designed to improve efficiency and reduce labor costs.'
    },
  ];

  ViewShareKnowledgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Share Knowledge'),
        backgroundColor: const Color(0xFF87CEEB),
      ),
      body: ListView.builder(
        itemCount: knowledgeItems.length,
        itemBuilder: (context, index) {
          final item = knowledgeItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    item['image']!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                      width: 24.0), // Increased space between image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          item['description']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReadMoreScreen(knowledgeItem: item),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF87CEEB), // Set button color
                          ),
                          child: const Text('Read Details'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
