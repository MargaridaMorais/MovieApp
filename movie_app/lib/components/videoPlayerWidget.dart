// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String keyVideo;
  const VideoPlayerWidget({Key? key, required this.keyVideo}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(
        initialVideoId: widget.keyVideo,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        )
    );

    return YoutubePlayer(
      // thumbnail: Image.network(widget.backdropPath),
      controller: _controller,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
        bufferedColor: Colors.grey,
        handleColor: Colors.red,
      ),
    );
  }
}
