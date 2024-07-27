import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import this for File

class ProductUploadScreen extends StatefulWidget {
  const ProductUploadScreen({super.key});

  @override
  _ProductUploadScreenState createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // List of categories
  final List<String> _categories = [
    'Vegetables',
    'Fruits',
    'Grains',
    'Dairy',
    'Meat',
    'Other',
  ];

  String? _selectedCategory;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        backgroundColor: const Color(0xFF87CEEB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: 'R ', // Add currency symbol
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Allow only digits
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value.replaceAll('R ', '')) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    if (_selectedCategory != 'Other') {
                      _categoryController
                          .clear(); // Clear the text field if not 'Other'
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              // Conditionally display text field for "Other" category
              if (_selectedCategory == 'Other')
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                      labelText: 'Specify Other Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please specify the category';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16.0),
              _imageFile == null
                  ? const Text('No image selected.')
                  : Image.file(File(_imageFile!.path)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEEB), // Set button color
                ),
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle the form submission and upload product
                    print('Product Name: ${_nameController.text}');
                    print('Price: ${_priceController.text}');
                    print('Location: ${_locationController.text}');
                    print('Description: ${_descriptionController.text}');
                    print('Category: $_selectedCategory');
                    if (_selectedCategory == 'Other') {
                      print('Specific Category: ${_categoryController.text}');
                    }
                    // Handle image upload
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEEB), // Set button color
                ),
                child: const Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
