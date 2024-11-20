import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantDetailPage extends StatefulWidget {
  final String id;
  final String restaurantName;

  const RestaurantDetailPage({
    Key? key,
    required this.id,
    required this.restaurantName, required restaurantId,
  }) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Map<String, dynamic>? restaurant;

  Future<void> fetchRestaurantDetail() async {
    final response = await http.get(
      Uri.parse('https://restaurant-api.dicoding.dev/detail/${widget.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        restaurant = jsonDecode(response.body)['restaurant'];
      });
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: restaurant == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant!['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('City: ${restaurant!['city']}'),
                  SizedBox(height: 8),
                  Text('Address: ${restaurant!['address']}'),
                  SizedBox(height: 8),
                  Text('Description: ${restaurant!['description']}'),
                  SizedBox(height: 8),
                  Text(
                    'Rating: ${restaurant!['rating']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
