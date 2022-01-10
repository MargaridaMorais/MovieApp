// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/components/moviePreviewModalWidget.dart';

// Small rectangle with image preview of the movie
Widget moviePreview(BuildContext context, Movie movie) { // this has to receive a movie object
  var url = movie.posterPath ??= ""; // assign empty string in case of null
  var finalUrl = url.isEmpty ? "https://bit.ly/3cuC5nS" : "https://image.tmdb.org/t/p/w500/" + url; // if string is empty show default image

  return GestureDetector(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        finalUrl,
        /*width: 120.0,
        height: 200.0,*/
        fit: BoxFit.fitHeight,
      ),
    ),
    onTap: () => { moviePreviewModalWidget(context, movie) },
  );
}