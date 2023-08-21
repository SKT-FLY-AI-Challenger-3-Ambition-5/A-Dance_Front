import 'dart:io';
import 'dart:math';

import 'package:a_dance/pages/adot_main.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
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

    _videoPlayerController.addListener(() {
      // 동영상이 끝났는지 확인
      if (_videoPlayerController.value.isBuffering &&
          _videoPlayerController.value.position ==
              _videoPlayerController.value.duration) {
        setState(() {});
      }
    });
  }

  Future<String?> uploadVideo(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('YOUR_SERVER_URL'));
    request.files.add(await http.MultipartFile.fromPath('video', filePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return null;
    }
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                // 상태를 업데이트하여 UI를 다시 빌드합니다.
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              });
            },
            child: Icon(
              _videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            tooltip: _videoPlayerController.value.isPlaying
                ? "Pause Video"
                : "Play Video",
          ),
          SizedBox(width: 10), // 버튼 사이의 간격
          FloatingActionButton(
            onPressed: () async {
              String? response = await uploadVideo(widget.videoPath);

              if (response != null) {
                // 여기서 response에 따라 다음 페이지로 넘어가거나 다른 작업을 수행하십시오.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Adot_Main())); // 임시로 Adot_Main
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to upload the video.")),
                );
              }
            },
            child: Icon(Icons.cloud_upload),
            tooltip: "Upload Video to Server",
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _saveVideoToGallery,
            child: Icon(Icons.save),
            tooltip: "Save Video to Gallery",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
