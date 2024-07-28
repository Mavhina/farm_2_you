
import 'package:farm2u/chats_screen.dart';
import 'package:farm2u/listings_provider.dart';
import 'package:farm2u/my_listings_screen.dart';
import 'package:farm2u/products_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ProductUploadScreen.dart';
import 'all_products_screen.dart';
import 'chat_screen.dart';
import 'drawer.dart';
import 'my_purchase_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ListingProductProvider(),
     child: MaterialApp(
       debugShowCheckedModeBanner: false,
        initialRoute: '/Home',
       routes: {
          '/Home' : (context) => AllProductsScreen(),
           '/MyListings' : (context) => MyListingsScreen(),
          '/Chats' : (context) => ChatScreen(),
         '/MyProducts' : (context) => MyPurchasesScreen()
       },
     ),
   )
  );
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomerDrawer(),
      appBar: AppBar(
        backgroundColor:Colors.green ,
        title: Text('Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body: Center(
        child: Text('Home'),
      ),

    );
  }
}


