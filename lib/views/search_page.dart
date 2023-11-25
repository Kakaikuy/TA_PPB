import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Show>> shows;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
  }

  Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse('https://www.fruityvice.com/api/fruit/all'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((item) => Show.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<List<Show>> searchShows(String query) async {
    final response = await http.get(Uri.parse('https://www.fruityvice.com/api/fruit/search?query=$query'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((item) => Show.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search shows');
    }
  }

  void onSearchPressed() {
    String query = searchController.text;
    shows = searchShows(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text('Pencarian Buah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) {
                      // Call the search function whenever the user types
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Check if the name contains the search query
                      if (snapshot.data![index].nama.toLowerCase().contains(searchController.text.toLowerCase())) {
                        return Card(
                          color: Colors.grey,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            title: Text(snapshot.data![index].nama),
                            subtitle: Text('genus: ${snapshot.data![index].genus}'),
                          ),
                        );
                      } else {
                        return SizedBox.shrink(); // Return an empty widget if the name doesn't match
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something is wrong with the API...'));
                }
                return const CircularProgressIndicator();
              },
              future: shows,
            ),
          ),
        ],
      ),
    );
  }
}

class Show {
  final int fruitId;
  final String nama;
  final String family;
  final String order;
  final String genus;

  Show({
    required this.fruitId,
    required this.nama,
    required this.family,
    required this.order,
    required this.genus,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      fruitId: json['id'],
      nama: json['name'],
      family: json['family'],
      order: json['order'],
      genus: json['genus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': fruitId,
        'name': nama,
        'family': family,
        'order': order,
        'genus': genus,
      };
}
