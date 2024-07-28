import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:farm2u/drawer.dart';
import 'package:flutter/material.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<Map<String,dynamic>> bids = [];
  Future<void>  getBids() async{
    try{
      var response = await http.post(
          Uri.parse('http://192.168.43.221:5076/getCustomerBid'),
          headers: {'Content-Type' : 'application/json'},
          body: jsonEncode({
            "customer_id" : 1
          })
      );

      var data = json.decode(response.body);
      if(data != null){
        setState(() {
          bids = List<Map<String,dynamic>>.from(data['info']);
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
    getBids();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomerDrawer(),
         appBar: AppBar(
           title: Text('My Listing',
             style: TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.bold,
             ),
           ),
             backgroundColor: Color(0xFF87CEEB),
           iconTheme: IconThemeData(
             color: Colors.white,
           ),
         ),
        body: GridView.builder(
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: bids.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              var bid = bids[index];
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
                            File(bid['image']),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),

                      Text('${bid['name']}',
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
                                'My Bid Price: R ${bid['price']}',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF87CEEB),
                                ),
                              ),
                              const SizedBox(
                                  height: 5.0
                              ),

                              Text(
                                'End date ${bid['end_date']}',
                                style: const TextStyle(
                                  fontSize: 10.0,
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
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(product: products[index],),

                                  ),
                                );*/
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
