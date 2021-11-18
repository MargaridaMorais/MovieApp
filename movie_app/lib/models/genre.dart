/*
* Class Genre
* This class contains all the properties needed to represent a genre.
* Properties:
*   String name
*   int id
* */

class Genre {
  final String name;
  final int id;

  Genre({
    required this.name,
    required this.id,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      name: json['name'],
      id: json['id'],
    );
  }
}