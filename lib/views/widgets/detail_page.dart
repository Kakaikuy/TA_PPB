import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ta_ppb/views/buah_page.dart';

class DetailPage extends StatelessWidget {
  final Show show;

  DetailPage({required this.show});

  Future<Map<String, dynamic>> fetchDetailedInfo(int fruitId) async {
    final response = await http.get(
        Uri.parse('https://www.fruityvice.com/api/fruit/$fruitId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detailed information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: fetchDetailedInfo(show.fruitId),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }

            var detailedInfo = snapshot.data!;
            var nutritionDetails = detailedInfo['nutritions'];

            if (nutritionDetails != null && nutritionDetails is Map) {
              // Assuming nutrition details are nested under 'nutritions'
              var calories = nutritionDetails['calories'];
              var fat = nutritionDetails['fat'];
              var sugar = nutritionDetails['sugar'];
              var carbohydrates = nutritionDetails['carbohydrates'];
              var protein = nutritionDetails['protein'];

              return Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${detailedInfo['name']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Order (Ordo): ${detailedInfo['order']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Family: ${detailedInfo['family']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Genus: ${detailedInfo['genus']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Calories: $calories',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Fat: $fat',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Sugar: $sugar',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Carbohydrates: $carbohydrates',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Protein: $protein',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Nutrition details not available'));
            }
          },
        ),
      ),
    );
  }
}
