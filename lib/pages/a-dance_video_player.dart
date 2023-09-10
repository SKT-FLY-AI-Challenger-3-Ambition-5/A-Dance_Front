import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:a_dance/main.dart';
import 'package:a_dance/pages/report.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:video_player/video_player.dart';

class VideoPlaybackScreen extends StatefulWidget {
  final String videoPath;
  final String youtube_url;
  final String title;
  final String artist;
  final List<List<Offset>> allFramesKeypoints;

  VideoPlaybackScreen(
      {required this.videoPath,
      required this.youtube_url,
      required this.title,
      required this.artist,
      required this.allFramesKeypoints});

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _videoPlayerController;
  bool initialized = false;
  bool isLoading = false; // Add this line

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

  Future<Tuple2<double, List<double>>>? uploadVideoScoring(
      {required String youtube_url,
      required String title,
      required String artist,
      required String username,
      required String filePath}) async {
    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse('$URL/api/scoring'));

    final jsonData =
        '{"youtube_url": "$youtube_url", "title": "$title", "artist": "$artist", "username": "$username"}';

    request.fields['data'] = jsonData;

    // 실배포용 비디오는 이거 써야함
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // // 비디오 테스트용
    // // final ByteData data = await rootBundle.load('assets/rev_hong.mp4');
    // final ByteData data = await rootBundle.load('assets/video1_30fps.mp4');
    // final List<int> bytes = data.buffer.asUint8List();
    // final Directory tempDir = Directory.systemTemp;
    // // final String tempPath =
    // //     '${tempDir.path}/${'assets/rev_hong.mp4'.split("/").last}';
    // final String tempPath =
    //     '${tempDir.path}/${'assets/video1_30fps.mp4'.split("/").last}';
    // final File tempFile = File(tempPath);
    // await tempFile.writeAsBytes(bytes, flush: true);
    // request.files.add(await http.MultipartFile.fromPath('file', tempPath));
    // // 테스트용 끝

    print('scoring request json = ${jsonData}');

    final response1 = await request.send();

    print('response1 statusCode = ${response1.statusCode}');

    setState(() {
      isLoading = false;
    });

    if (response1.statusCode == 200) {
      final response = await http.Response.fromStream(response1);
      final responseData = jsonDecode(response.body);
      final double pck_30 = responseData['pck_30'];
      final List<double> pck_frame_score =
          List<double>.from(responseData['pck_frame_score']);
      return Tuple2(pck_30, pck_frame_score);
    }

    return Tuple2(0, [0]);
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
      body: Stack(
        children: [
          Center(
            child: initialized
                ? Transform.scale(
                    scale: 1.9,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: AspectRatio(
                        aspectRatio:
                            1 / _videoPlayerController.value.aspectRatio,
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
          if (isLoading) ...[
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/adot-char.gif',
                    height: 120,
                  ),
                  Text(
                    '     채점 중이에요!\n잠시만 기다려 주세요!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
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
          SizedBox(width: 10),
          FloatingActionButton(
            // onPressed: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => Report(
            //                 title: widget.title,
            //               )));
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              String? userName = await _showNameDialog(context);

              if (userName != null && userName.isNotEmpty) {
                Tuple2<double, List<double>>? response =
                    await uploadVideoScoring(
                        username: userName,
                        artist: widget.artist,
                        filePath: widget.videoPath,
                        title: widget.title,
                        youtube_url: widget.youtube_url);

                setState(() {
                  isLoading = false;
                });

                if (response != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Report(
                                title: widget.title,
                                score: response.item1,
                                frame_score: response.item2,
                                allFramesKeypoints: widget.allFramesKeypoints,
                                videoPath: widget.videoPath,
                                username: userName,
                              )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to upload the video.")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Name is required to upload the video.")),
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

Future<String?> _showNameDialog(BuildContext context) async {
  TextEditingController _nameController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("닉네임을 입력해주세요"),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: "닉네임"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
            },
          ),
          TextButton(
            child: Text("Submit"),
            onPressed: () {
              Navigator.of(context)
                  .pop(_nameController.text.trim()); // 이름을 반환하고 다이얼로그를 닫습니다.
            },
          ),
        ],
      );
    },
  );
}
