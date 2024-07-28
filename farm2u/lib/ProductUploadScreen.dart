import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'drawer.dart';


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
  var filaname;

  Future<void> addProuct() async{
    try{
      var response = await http.post(
        Uri.parse('http://192.168.43.221:5076/addproduct'),
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({
            "name" : _nameController.text,
            "description" : _descriptionController.text,
            "category" : _categoryController.text,
            "price" : _priceController.text,
            "image" : '${filaname}',
            "farmer_id" : 1
        })
      );

    }
    catch(e){
      throw e;
    }
  }

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
      filaname = pickedFile!.path;
      print('file path: ${filaname}');

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      drawer: CustomerDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Product Name',
                       border: OutlineInputBorder(
                         borderSide:  BorderSide(
                           color: Colors.black,
                         ),
                         borderRadius: BorderRadius.circular(10.0),
                       )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration:  InputDecoration(
                    labelText: 'Price',
                    prefixText: 'R ',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )
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
                SizedBox(
                  height: 10.0,
                ),

                TextFormField(
                  controller: _locationController,
                  decoration:  InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
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
                            .clear();
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
        
                if (_selectedCategory == 'Other')
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                        labelText: 'Specify Other Category',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        )

                    ),
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
                  onPressed: (){
                    _pickImage();
                    print('file of the picture$filaname');
                  },
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
                      addProuct();
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
      ),
    );
  }
}
