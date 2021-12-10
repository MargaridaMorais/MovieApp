// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/components/genreWidget.dart';
import 'package:movie_app/models/genre.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// TODO add padding to the scrollbars
class _HomeScreenState extends State<HomeScreen> {
  final Future<List<Genre>> _fetchedGenres = fetchGenres();

  Widget genreScroll(List<Genre> genres) {
    return Scrollbar(
      child: ListView.separated(
        shrinkWrap: true,
        // padding: const EdgeInsets.all(10.0),
        itemCount: genres.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 30.0,
            thickness: 3.0,
          );
        },
        itemBuilder: (context, index) {
          return GenreWidget(genre: genres[index]);
        },
      ));
  }

  //  Build the top bar with the movie app logo and the genres scroll
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Align(
                  child: Image.asset("assets/images/logo.png", height: 30,),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Expanded(
                // margin: const EdgeInsets.all(5.0),
                child: FutureBuilder(
                  future: _fetchedGenres,
                  builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
                    if (snapshot.hasData) {
                      var genres = snapshot.data ?? [];
                      return genreScroll(genres);
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Icon(Icons.error_outline, color: Colors.red, size: 60),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                      );
                    }
                  }
                ),
              ),
            ],
          ),
        )
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
