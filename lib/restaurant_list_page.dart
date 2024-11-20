import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurant_detail_page.dart';
import 'favorite_page.dart'; // Import halaman favorit

class RestaurantListPage extends StatelessWidget {
  Future<List<dynamic>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['restaurants'];
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritePage()),
              );
            },
          ),
        ],
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
      body: FutureBuilder<List<dynamic>>(
        future: fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load restaurants: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final restaurant = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant['pictureId']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      restaurant['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('City: ${restaurant['city']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            id: restaurant['id'],
                            restaurantName: restaurant['name'], restaurantId: null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No restaurants found'));
          }
        },
      ),
    );
  }
}
