import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ta_ppb/views/widgets/detail_page.dart';

class BuahPage extends StatefulWidget {
  @override
  _BuahPageState createState() => _BuahPageState();
}

class _BuahPageState extends State<BuahPage> {
  late Future<List<Show>> shows;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text('Detail Buah'),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<List<Show>> snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        // Navigate to a new page with details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              show: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.grey,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          title: Text(snapshot.data![index].nama),
                          subtitle:
                              Text('genus: ${snapshot.data![index].genus}'),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Something is wrong with the API...'));
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
  //Sesuaikan data frutiy
  final int fruitId;
  final String nama;
  final String family;
  final String order;
  final String genus;
  // List nutrisi;

  Show({
    //TODO Ini juga
    required this.fruitId,

    // required this.nutrisi,
    required this.nama,
    required this.family,
    required this.order,
    required this.genus,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      //diubah
      fruitId: json['id'],

      nama: json['name'],
      family: json['family'],
      order: json['order'],
      genus: json['genus'],
      // nutrisi: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': fruitId,
        //Diubah
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