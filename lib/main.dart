import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(GameListView());
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}*/

class Game {
  String amiiboSeries;
  String character;
  String gameSeries;
  String image;
  Object release;

  Game(
      {this.amiiboSeries,
      this.character,
      this.gameSeries,
      this.image,
      this.release});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        amiiboSeries: json['amiiboSeries'],
        character: json['character'],
        gameSeries: json['gameSeries'],
        image: json['image'],
        release: json['relese']);
  }
}

Future<List<Game>> fetchGameFromAmiibo() async {
  var response = await http.get('https://www.amiiboapi.com/api/amiibo/');

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((item) => new Game.fromJson(item)).toList();
    //return Game.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("${response.statusCode} - ${response.body}");
  }
}

// class MyHomePage extends StatefulWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('qqr coisa'),
//         ),
//         body: Center(
//           child: GameListView()
//         ));
//   }

// }

ListView _gameListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(
            data[index].amiiboSeries, data[index].character, Icons.work);
      });
}

ListTile _tile(String amiiboSeries, String character, IconData icon) =>
    ListTile(
      title: Text(amiiboSeries,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(character, textDirection: TextDirection.ltr),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
// }

class GameListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: fetchGameFromAmiibo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Game> data = snapshot.data;
          return _gameListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", textDirection: TextDirection.ltr);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
