import 'dart:convert';
import 'dart:io';

import 'package:farm2u/drawer.dart';
import 'package:farm2u/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String,dynamic>> products = [];


  List<Map<String,dynamic>> auctionproducts = [];

  Future<void> getProducts() async {
    try{
      var response = await http.get(
        Uri.parse('http://192.168.43.221:5076/getauctionedproducts'),
      );

      var data = json.decode(response.body);
      if(data['info'] != null)
        {
        setState(() {
          products = List<Map<String,dynamic>>.from(data['info']);
        });
        }
    }
    catch(e){
      throw e;
    }
  }
  Future<void> getAuctionedProducts() async{
    try{
      var response = await http.post(
        Uri.parse(''),
      );

      var data = json.decode(response.body);
      if(data != null){
        if(data['info'] != null){
          setState(() {
            auctionproducts = List<Map<String,dynamic>>.from(data['info']);
          });
        }
      }
    }
    catch(e){
      throw e;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomerDrawer(),

      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        shrinkWrap: true,
           itemCount: products.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) {
          var product = products[index];
            return Container(

              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                  border:Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      right: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRect(
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          File(product['image']),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Text('${product['name']}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minimum Bid Price: R ${product['price']}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF87CEEB),
                              ),
                            ),
                            const SizedBox(
                                height: 5.0
                            ),

                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              borderRadius: BorderRadius.circular(6.0)
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: (){
                              print('product pressed : $index');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(product: products[index],),

                                  ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
      )
    );
  }
}
