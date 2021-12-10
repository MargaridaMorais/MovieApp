// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/components/moviePreviewModal.dart';

class GenreWidget extends StatefulWidget {
  final Genre genre;
  // const GenreWidget(this.genre);
  const GenreWidget({Key? key, required this.genre}) : super(key: key);

  @override
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  final ScrollController _controller = ScrollController();
  final List<Movie> _movies = []; // current movie list to be displayed
  int _currentPage = 1; // last page to be loaded in the results
  bool loading = false; // loading means it's currently loading movies
  bool allLoaded = false; // allLoaded means all movies available in the results query have been loaded, there are no more movies

  @override
  void initState() {
    super.initState();

    _fetchMovies();

    _controller.addListener(() {
      // The listener function will fetch more movies to show whenever the user reaches the end of the list and no movies are being loaded already
      if (_controller.position.pixels >= _controller.position.maxScrollExtent && !loading) {
        _fetchMovies();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Fetch the movies related to the specific genre
  void _fetchMovies() async {
    if (allLoaded) {
      // if no more movies then return nothing
      return ;
    }

    setState(() {
      loading = true;
    });

    fetchMoviesPerGenre(widget.genre.id, _currentPage).then((res) {
      setState(() {
        _movies.addAll(res[1]); // add all new fetched movies to the movie list to be shown
        if (res[0] == _currentPage) {
          // if the page being currently loaded corresponds to the max number of result pages than all results have been loaded
          allLoaded = true;
        }
        _currentPage++;
      });
    });

    setState(() {
      loading = false;
    });
  }

  // Small rectangle with image preview of the movie
  Widget moviePreview(Movie movie) { // this has to receive a movie object
    var url = movie.posterPath ??= ""; // assign empty string in case of null
    var finalUrl = url.isEmpty ? "https://bit.ly/3cuC5nS" : "https://image.tmdb.org/t/p/w500/" + url; // if string is empty show default image

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          finalUrl,
          width: 120.0,
          height: 200.0,
          fit: BoxFit.fitHeight,
        ),
      ),
      onTap: () => { movieModal(context, movie) },
    );
  }

  // TODO change the movie scroll into reusable code to be used in the related movies scroll
  Widget movieScroll() {
    return Scrollbar(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 10.0,
            );
          },
          controller: _controller,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _movies.length,

          itemBuilder: (context, index) {
            return moviePreview(_movies[index]);
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.genre.name, style: const TextStyle(fontFamily: "Graph", fontSize: 30.0))
        ),
        const SizedBox(height: 10.0), // Sized box to separate text and listview
        SizedBox(
          height: 200.0,
          child: movieScroll(),
        ),
        // FloatingActionButton(onPressed: () async => await fetchMoviesPerGenre(28, 1))
      ],
    );
  }
}
