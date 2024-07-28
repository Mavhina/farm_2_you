import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';


class MyPurchasesScreen extends StatefulWidget {
  const MyPurchasesScreen({super.key});

  @override
  State<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  List<Map<String,dynamic>> products = [];

  Future<void> getMyProducts() async{

    try{
      var response = await http.post(
        Uri.parse('http://192.168.43.221:5076/getcustomerproducts'),
        headers: {
          'Content-Type' : 'application/json'
        },
        body: jsonEncode({
          "customer_id" : 1
        })
      );

      var data = json.decode(response.body);

      if(data != null){
        setState(() {
          products = List<Map<String,dynamic>>.from(data['info']);
        });
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
    getMyProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomerDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF87CEEB) ,
          title: Text('My Products',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                                'Price: R ${product['price']}',
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
