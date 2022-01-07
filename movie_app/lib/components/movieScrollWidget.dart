// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:movie_app/components/moviePreviewWidget.dart';

import 'package:movie_app/models/movie.dart';

Widget movieScroll(BuildContext context, ScrollController _controller, List<Movie> _movies) {
  return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
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
            return moviePreview(context, _movies[index]);
          },
        ),
      )
  );
}