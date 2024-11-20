import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'restaurant_list_page.dart';
import 'package:responsi/favorite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FavoritePage()));
            },
          ),
        ],
      ),
      body: RestaurantListPage(),
    );
  }
  
  FavoritePage() {}
}
