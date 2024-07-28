import 'package:flutter/material.dart';


class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF87CEEB),
            ),
            accountName: Text('Current User'),
            accountEmail: const Text('twarisanin@gmail.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40.0,
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.list_alt),
            title: const Text('My Listings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/MyListings');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.shopping_cart),
            title: const Text('My Purchases'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/MyProducts');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.book_sharp),
            title: const Text('My Courses'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/MyCourses');
            },
          ),
          ListTile(
            trailing: Badge.count(
              count: 2,
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.chat,
              ),
            ),
            title: const Text('Chats'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Chats');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
