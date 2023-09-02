import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:video_player/video_player.dart';

class Result_Analysis extends StatefulWidget {
  final String videoPath;
  final List<List<Offset>> allFramesKeypoints;
  final int badStart;
  final double badFrametime;

  Result_Analysis(
      {required this.videoPath,
      required this.allFramesKeypoints,
      required this.badStart,
      required this.badFrametime});

  @override
  State<Result_Analysis> createState() => _Result_Analysis();
}

class _Result_Analysis extends State<Result_Analysis> {
  late final videoPlayerController;
  late List<Offset> keypoints;
  double sliderValue = 0;
  late Timer _timer;
  bool isInitialized = false;
  bool isKeypointsInitialized = false;
  late double sliderMinValue;
  late double sliderMaxValue; // 1초를 밀리초로 변환

  @override
  void initState() {
    super.initState();

    keypoints = widget.allFramesKeypoints[widget.badStart];

    int badFrametimeInMilliseconds = (widget.badFrametime * 1000).toInt();

    sliderMinValue = badFrametimeInMilliseconds.toDouble();
    sliderMaxValue = (badFrametimeInMilliseconds + 1000).toDouble();
    sliderValue = sliderMinValue;

    _timer = Timer.periodic(Duration(milliseconds: 132), (Timer timer) {
      // 약 30fps
      double nextValue = sliderValue + 16; // 16ms 증가 (약 15fps)
      if (nextValue > sliderMaxValue) {
        nextValue = sliderMinValue; // 최대 값에 도달하면 다시 최소 값으로
      }
      sliderValue = nextValue;

      // 슬라이더 값에 따라 동영상과 키포인트 업데이트
      videoPlayerController.seekTo(Duration(milliseconds: sliderValue.toInt()));
      print('sliderValue = ${sliderValue.toInt()}');

      int frameIndex =
          ((sliderValue - sliderMinValue) / (1000 / 30)).toInt(); // 30fps
      if (frameIndex + widget.badStart < widget.allFramesKeypoints.length) {
        keypoints = widget.allFramesKeypoints[frameIndex + widget.badStart];
      }

      setState(() {}); // UI 업데이트
    });

    initAsync().then((_) {
      setState(() {
        isInitialized = true;
        isKeypointsInitialized = true;
      });
    });
  }

  Future<void> initAsync() async {
    // trimVideo 함수를 비동기적으로 호출
    // String trimmedPath = await trimVideo(widget.videoPath, widget.badFrametime);

    videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _timer.cancel();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    if (!isKeypointsInitialized) {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('결과 화면'),
      ),
      body: Column(
        children: [
          // 추가하고 싶은 다른 위젯들...
          Expanded(
            child: videoPlayerController.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.8,
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: AspectRatio(
                            aspectRatio:
                                1 / videoPlayerController.value.aspectRatio,
                            child: Transform(
                                transform: Matrix4.identity()
                                  ..scale(1.0, -1.0, 1.0),
                                alignment: Alignment.center,
                                child: VideoPlayer(videoPlayerController)),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: CustomPaint(
                          painter: PosePainter(keypoints: keypoints),
                          size: MediaQuery.of(context).size,
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Slider(
            value: sliderValue,
            min: sliderMinValue,
            max: sliderMaxValue,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
                videoPlayerController
                    .seekTo(Duration(milliseconds: value.toInt()));

                int frameIndex =
                    ((value - sliderMinValue) / (1000 / 30)).toInt(); // 30fps
                if (frameIndex + widget.badStart <
                    widget.allFramesKeypoints.length) {
                  keypoints =
                      widget.allFramesKeypoints[frameIndex + widget.badStart];
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Tuple2<int, int>> connections = [
    Tuple2(0, 1),
    Tuple2(0, 2),
    Tuple2(3, 5),
    Tuple2(4, 6),
    Tuple2(5, 7),
    Tuple2(6, 8),
    Tuple2(9, 11),
    Tuple2(10, 12),
    Tuple2(11, 13),
    Tuple2(12, 14),
    Tuple2(3, 4),
    Tuple2(4, 10),
    Tuple2(10, 9),
    Tuple2(9, 3)
  ];
  late final List<Offset> keypoints;
  final Color lineColor = Colors.white.withOpacity(0.9);
  final Color circleColor = Colors.green.withOpacity(0.9);

  PosePainter({required this.keypoints});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 10.0;
    final circlePaint = Paint()..color = circleColor;

    print('size.height = ${size.height}');

    // Draw connections
    for (var connection in connections) {
      if (connection.item1 < keypoints.length &&
          connection.item2 < keypoints.length) {
        final start = Offset(keypoints[connection.item1].dx * size.width,
            keypoints[connection.item1].dy * size.height);
        final end = Offset(keypoints[connection.item2].dx * size.width,
            keypoints[connection.item2].dy * size.height);
        canvas.drawLine(start, end, linePaint);
      }
    }

    // Draw keypoints
    for (var idx = 0; idx < 15; idx++) {
      final point = Offset(
          keypoints[idx].dx * size.width, keypoints[idx].dy * size.height);
      if (idx == 0) {
        canvas.drawCircle(point, 30.0, circlePaint);
      } else if (idx == 1 || idx == 2) {
        continue;
      } else {
        canvas.drawCircle(point, 10.0, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
