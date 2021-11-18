// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/models/genre.dart';

class GenreWidget extends StatefulWidget {
  // const GenreWidget({Key? key}) : super(key: key);

  final Genre genre;
  const GenreWidget(this.genre);

  @override
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  final ScrollController _controller = ScrollController();
  List<Movie> _movies = [];
  int _currentPage = 1;
  bool loading = false, allLoaded = false;

  @override
  void initState() {
    super.initState();

    _fetchMovies();
    
    _controller.addListener(() {
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

  void _fetchMovies() async {
    if (allLoaded) {
      return ;
    }

    setState(() {
      loading = true;
    });

    fetchMoviesPerGenre(widget.genre.id, _currentPage).then((res) {
      setState(() {
        _movies.addAll(res[1]);
        if (res[0] == _currentPage) {
          allLoaded = true;
        }
        _currentPage++;
      });
    });

    setState(() {
      loading = false;
    });
  }

  Widget moviePreview(Movie movie) { // this has to receive a movie object
    var url = movie.posterPath ??= ""; // assign empty string in case of null

    var finalUrl = url.isEmpty ? "https://bit.ly/3cuC5nS" : "https://image.tmdb.org/t/p/w500/" + url;

    return(ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        finalUrl,
        width: 120.0,
        height: 200.0,
        fit: BoxFit.fitHeight,
      ),
    ));
  }

  Widget movieScroll() {
    return ListView.separated(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.genre.name, style: TextStyle(fontSize: 30.0),),
        ),
        SizedBox(
          height: 200.0,
          child: movieScroll(),
        ),
        // FloatingActionButton(onPressed: () async => await fetchMoviesPerGenre(28, 1))
      ],
    );
  }
}
