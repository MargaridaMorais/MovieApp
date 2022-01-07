// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/components/videoPlayerWidget.dart';
import 'package:movie_app/components/movieSimilarsWidget.dart';

// TODO: this has to be changed to a real screen and not a modal

Future moviePreviewModalWidget(BuildContext context, Movie movie) {
  var urlBackdrop = movie.backdropPath ??= ""; // assign empty string in case of null
  urlBackdrop = urlBackdrop.isEmpty ? "https://bit.ly/3cuC5nS" : "https://image.tmdb.org/t/p/w1280/" + urlBackdrop;

  final Future<String> _keyVideo = fetchMovieVideo(movie.movieId);

  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Column(
        // dragStartBehavior: DragStartBehavior.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
              child: FutureBuilder(
                future: _keyVideo,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return VideoPlayerWidget(keyVideo: snapshot.data);
                  } else if (snapshot.hasError) {
                    // Show the backdrop of the movie if video is unavailable
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
                    return const SizedBox(
                      height: 250,
                    );
                  }
                },
              )
          ),
          const SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
              Text(
                movie.title ??= "No title",
                style: const TextStyle(fontFamily: "Graph", fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
              Row(
                children: [
                  const Text(
                    "Average Rate: ",
                    style: TextStyle(fontFamily: "Graph", fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movie.rate.toString(),
                    style: const TextStyle(fontFamily: "Graph", fontSize: 17.0,),
                  ),
                  Text(
                    " (" + movie.voteCount.toString() + ")",
                    style: const TextStyle(fontFamily: "Graph", fontSize: 17.0, color: Colors.grey),
                  ),
                ],
              ),
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
              Row(
                children: [
                  const Text(
                    "Release Year: ",
                    style: TextStyle(fontFamily: "Graph", fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (movie.releaseDate ??= "No date"),
                    style: const TextStyle(fontFamily: "Graph", fontSize: 17.0,),
                  ),
                ],
              ),
          ),
          const SizedBox(height: 10.0,),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child:
              SingleChildScrollView(
                child: Text(
                  movie.overview ??= "No overview",
                  softWrap: true,
                  style: const TextStyle(fontFamily: "Graph", fontSize: 17.0,),
                ),
                scrollDirection: Axis.vertical,
              ),
            )
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: movieSimilarsWidget(movieId: movie.movieId),
          ),
        ],
      );
    },
    context: context,
  );
}