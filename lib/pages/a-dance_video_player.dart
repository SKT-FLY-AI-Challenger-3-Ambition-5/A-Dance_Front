import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VideoPlaybackScreen extends StatefulWidget {
  final String videoPath;

  VideoPlaybackScreen({required this.videoPath});

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _videoPlayerController;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          initialized = true;
        });
        _videoPlayerController.play(); // 영상을 자동으로 재생합니다.
      });
  }

  _saveVideoToGallery() {
    GallerySaver.saveVideo(widget.videoPath).then((bool? success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(success!
                ? "Video saved to gallery successfully!"
                : "Error saving video to gallery.")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Playback'),
      ),
      body: Center(
        child: initialized
            ? Transform.scale(
                scale: 1.9,
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: AspectRatio(
                    aspectRatio: 1 / _videoPlayerController.value.aspectRatio,
                    child: Transform(
                      transform: Matrix4.identity()..scale(1.0, -1.0, 1.0),
                      alignment: Alignment.center,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveVideoToGallery,
        child: Icon(Icons.save),
        tooltip: "Save Video to Gallery",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
