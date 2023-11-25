import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class GachaPage extends StatefulWidget {
  @override
  _GachaPageState createState() => _GachaPageState();
}

class _GachaPageState extends State<GachaPage> {
  late Future<List<Show>> shows;
  late Show selectedFruit;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
    selectedFruit = Show(
      fruitId: 0,
      nama: '',
      family: '',
      order: '',
      genus: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text('Gacha Buah'),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<List<Show>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the specified thumbnail
                  Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2z-SJzBDu4SzTL1t7pKRc-YPOta5VjVyc1w&usqp=CAU',
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      title: Text(selectedFruit.nama),
                      subtitle: Text(
                        'genus: ${selectedFruit.genus}',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Select a random fruit when the button is pressed
                      setState(() {
                        selectedFruit = snapshot.data![Random().nextInt(snapshot.data!.length)];
                      });
                    },
                    child: Text('Gacha'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something is wrong with the API...'),
              );
            }
            return const CircularProgressIndicator();
          },
          future: shows,
        ),
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

Future<List<Show>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://www.fruityvice.com/api/fruit/all'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((item) => Show.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
