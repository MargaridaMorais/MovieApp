// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/genre.dart';

const _apiKey = "af6d7f4ac657b5f325d788bcb28209bd"; // key for the API calls, for now it's here just for testing

Future<List> fetchSimilarMovies(int movieId) async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/' + movieId.toString() + '/similar?api_key='
      + _apiKey + '&language=en-US'));

  int qtMovies = 6; // number of movies to return
  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    Iterable res = decoded['results'].take(qtMovies); // Get first qtMovies number of movies from the list
    List<Movie> movies = List<Movie>.from(res.map((movie) => Movie.fromJson(movie)));
    return movies;
  } else {
    throw Exception('Failed to get results');
  }
}

Future<String> fetchMovieVideo(int movieId) async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/' + movieId.toString() + '/videos?api_key='
      + _apiKey + '&language=en-US'));

  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    for (var video in decoded['results']) {
      if (video['type'] == "Trailer" && video['official'] == true && video['site'] == "YouTube") {
        return video['key'];
      }
    }
    throw Exception('Failed to get results');
  } else {
    throw Exception('Failed to get results');
  }
}

Future<List> fetchMoviesPerGenre(int genreId, int pages) async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=' + _apiKey + '&language=en-US&page='
      + pages.toString() + '&with_genres=' + genreId.toString()));

  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body); // decode the body of the response into Json format

    int totalPages = decoded['total_pages']; // total pages of the search in this genre

    Iterable moviesResult = decoded['results']; // array object containing all the movies resulting of the search
    List<Movie> movies = List<Movie>.from(moviesResult.map((movie) => Movie.fromJson(movie)));

    return [totalPages, movies];
  } else {
    throw Exception('Failed to get results');
  }
}

Future<List<Genre>> fetchGenres() async {
  final response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=' + _apiKey + '&language=en-US'));

  if (response.statusCode == 200) {
    Iterable decoded = jsonDecode(response.body)['genres']; // this returns a list of genres, so we have to call Genre.fromJson for each object in the list to create several objects
    List<Genre> genres = List<Genre>.from(decoded.map((genre) => Genre.fromJson(genre)));
    return genres;
  } else {
    throw Exception('Failed to get genres');
  }
}

/*
Future<Movie> fetchMovie() async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/703771?api_key=af6d7f4ac657b5f325d788bcb28209bd&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Movie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load movie');
  }
}*/
