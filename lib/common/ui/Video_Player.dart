import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video_Player extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const Video_Player({
    Key key,
    this.videoPlayerController,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Video_Player> {
  ChewieController chewieController;

  @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      showControlsOnInitialize: true,
      allowedScreenSleep: true,
      allowPlaybackSpeedChanging: true,

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }

  @override
  void dispose() {
    //chewieController.dispose();
    super.dispose();
  }
}
