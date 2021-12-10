/*
* Class Movie
* This class contains all the properties needed to represent the movie object.
* Properties:
*   String title
*   int rate
*   int vote_count
*   String release_date
*   String backdrop_path (path to retrieve the backdrop image that will be shown)
*   [String] genres (genres to show) TO ADD
*   String overview (description of the movie)
*   int id (movie_id used to send to the api)
* */

class Movie {
  String? title;
  String? posterPath;
  String? backdropPath;
  String? overview;
  String? releaseDate;
  int movieId;
  int? voteCount;
  num? rate;

  Movie({
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.movieId,
    required this.voteCount,
    required this.rate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      movieId: json['id'],
      voteCount: json['vote_count'],
      rate: json['vote_average'],
    );
  }
}