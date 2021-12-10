// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/components/videoPlayerWidget.dart';


Future movieModal(BuildContext context, Movie movie) {
  var urlBackdrop = movie.backdropPath ??= ""; // assign empty string in case of null
  urlBackdrop = urlBackdrop.isEmpty ? "https://bit.ly/3cuC5nS" : "https://image.tmdb.org/t/p/w780/" + urlBackdrop;

  final Future<String> _keyVideo = fetchMovieVideo(movie.movieId);

  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
              // child: Image.network(finalUrl),
              child: FutureBuilder(
                future: _keyVideo,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return VideoPlayerWidget(keyVideo: snapshot.data);
                  } else if (snapshot.hasError) {
                    return ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(urlBackdrop),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
          ),
          const SizedBox(height: 20.0,),
          Text(
            movie.title ??= "No title",
            style: const TextStyle(fontFamily: "Graph", fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0,),
          Text(
            "Average Rate: " + movie.rate.toString() + " (" + movie.voteCount.toString() + ")",
            style: const TextStyle(fontFamily: "Graph", fontSize: 20.0,),
          ),
          const SizedBox(height: 10.0,),
          Text(
            "Release Year: " + (movie.releaseDate ??= "No date"),
            style: const TextStyle(fontFamily: "Graph", fontSize: 17.0,),
          ),
          const SizedBox(height: 10.0,),
          Text(
            movie.overview ??= "No overview",
            softWrap: true,
            style: const TextStyle(fontFamily: "Graph", fontSize: 17.0,),
          ),
        ],
      );
    },
    context: context,
  );
}