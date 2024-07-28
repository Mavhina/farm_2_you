import 'package:farm2u/products_screen.dart';
import 'package:farm2u/sale_products.dart';
import 'package:farm2u/drawer.dart';
import 'package:flutter/material.dart';

import 'courses.dart';


class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
         child: Scaffold(
           drawer: CustomerDrawer(),
           appBar: AppBar(
             iconTheme: IconThemeData(
               color: Colors.white,
             ),
             backgroundColor: const Color(0xFF87CEEB),
             title: Text(
               'Products',
               style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
               ),
             ),
             bottom: TabBar(
               indicatorColor: Colors.white,
               tabs: [
                 Tab(
                   child: Text('Sale Products',
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 Tab(
                   child: Text('Auctioned Products',
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 Tab(
                   child: Text('Courses',
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 )
               ],
             ),
           ),
           body: TabBarView(
             children: [
               SaleProductsScreen(),
               ProductsScreen(),
               CoursesScreen()
             ],
           ),
         ),
    );
  }
}
