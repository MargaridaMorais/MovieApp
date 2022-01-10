// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/components/movieScrollWidget.dart';


class movieSimilarsWidget extends StatefulWidget {
  final int movieId;
  const movieSimilarsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  _movieSimilarsWidgetState createState() => _movieSimilarsWidgetState();
}

class _movieSimilarsWidgetState extends State<movieSimilarsWidget> {
  final ScrollController _controller = ScrollController();

  Widget buildSimilarMoviesPreview(BuildContext context, List<Movie> movies) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: movieScroll(context, _controller, movies),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<List> _movies = fetchSimilarMovies(widget.movieId);

    return FutureBuilder(
      future: _movies,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return buildSimilarMoviesPreview(context, snapshot.data);
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
    );
  }
}
