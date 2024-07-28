import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyProdAuctionDetails extends StatefulWidget {
  MyProdAuctionDetails({required this.product,super.key});
  Map<String,dynamic> product;

  @override
  State<MyProdAuctionDetails> createState() => _MyProdAuctionDetailsState();
}

class _MyProdAuctionDetailsState extends State<MyProdAuctionDetails> {
  Future<void>  addBid() async{
    try{
      var response = http.post(
        Uri.parse(''),
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({
          "customer_id" : 1,
          "auction_id" : widget.product['product_id']
        })
      );
    }
    catch(e){
      throw e;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF87CEEB),
        title: const Text('Product Details',
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
                  child: Image.file(
                    File(widget.product['image']),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product['name']}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${widget.product['description']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),

                    Text(
                      'Minimum Bid Price: R${widget.product['price']}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CEEB),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Start date ${widget.product['start_date']}',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Start date ${widget.product['end_date']}',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CEEB),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF87CEEB),
                            ),
                            child: const Text(
                              'Place Listing',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: (){

                            },
                          ),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, '/Chats');
                          },
                          icon: Icon(
                            Icons.chat,
                          ),
                        )
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

