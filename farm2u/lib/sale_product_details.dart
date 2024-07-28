import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'all_products_screen.dart';
import 'listings_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaleProductDetails extends StatefulWidget {
  SaleProductDetails({required this.product, super.key});
  final Map<String, dynamic> product;

  @override
  State<SaleProductDetails> createState() => _SaleProductDetailsState();
}

class _SaleProductDetailsState extends State<SaleProductDetails> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
    } else if (await Permission.manageExternalStorage.request().isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
    } else {
      // Handle the case where the user denies the permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to view the image.')),
      );
    }
  }

  Future<void> addMyProduct() async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.221:5076/addcustomerproduct'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "customer_id": 1,
          "product_id": widget.product['product_id']
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingProvider = Provider.of<ListingProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF87CEEB),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Using a direct image URL for demonstration
              ClipRect(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: _permissionsGranted
                      ? FutureBuilder(
                    future: _requestPermissions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final file = File(widget.product['image']);
                        if (file.existsSync()) {
                          return Image.file(
                            file,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const Center(child: Text('Image not found'));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                      : const Center(child: Text('Permission not granted')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product['name']}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${widget.product['description']}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Price: R${widget.product['price']}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF87CEEB),
                            ),
                            child: const Text(
                              'Buy',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              addMyProduct();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllProductsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/Chats');
                          },
                          icon: const Icon(
                            Icons.chat,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
