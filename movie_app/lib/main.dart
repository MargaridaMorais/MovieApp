import 'package:flutter/material.dart';

import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/components/genreWidget.dart';
import 'package:movie_app/models/genre.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Genre g = Genre(name: "Action", id: 28);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie App'),
        ),
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: GenreWidget(g),
        ),
      ),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
      ),
    );
  }
}