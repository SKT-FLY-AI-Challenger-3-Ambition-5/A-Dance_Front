import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                height: 2200,
                decoration: BoxDecoration(
                  color: Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(-1, -4),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 1,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.white,
                          onPressed: () {
                            //버튼 클릭 시 수행할 작업

                          },
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Text(
                          "결과 분석 영상",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 70),
                        Builder(
                          builder: (BuildContext builderContext) {
                            return IconButton(
                              icon: Icon(Icons.more_vert_rounded),
                              color: Colors.white,
                              onPressed: () {
                                // 버튼 클릭 시 팝업 띄우기
                                showDialog(
                                  context: builderContext, // Builder 위젯의 컨텍스트 사용
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40.0)
                                      ),
                                        title: Row(
                                          children: [
                                            Icon(Icons.share, size: 23,),
                                            SizedBox(width: 10),
                                            Text("공유하기",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        content: Row(
                                          children: [
                                            Icon(Icons.download_sharp),
                                            SizedBox(width: 10,),
                                            Text("비교영상 다운로드",style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                                          ],
                                        ),

                                        actions: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //두개의 리스트 생성해서 넣기
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                              ),

                                            ],
                                          ),

                                        ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 1),
                      ],
                    ),
                    VideoScrubber(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoScrubber extends StatefulWidget {
  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<VideoScrubber> {
  late VideoPlayerController _controller;
  double scrubPosition = 10.0;
  List<Duration> _thumbnailPositions = [];
  late Duration totalDuration;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _calculateThumbnailPositions();
  }

  void _calculateThumbnailPositions() {
    _thumbnailPositions.clear();
    int totalDuration = _controller.value.duration.inSeconds;
    int numberOfThumbnails = 10; // You can adjust the number of thumbnails
    int interval = (totalDuration / numberOfThumbnails).toInt();

    for (int i = 0; i < numberOfThumbnails; i++) {
      _thumbnailPositions.add(Duration(seconds: interval * i));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //시점 List
  List<Duration> _specialPoints = [
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 700,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      double totalWidth = MediaQuery
                          .of(context)
                          .size
                          .width;
                      double newPosition = scrubPosition +
                          details.delta.dx / totalWidth *
                              _controller.value.duration.inSeconds;
                      if (newPosition < 0) {
                        newPosition = 0;
                      } else if (newPosition >
                          _controller.value.duration.inSeconds) {
                        newPosition =
                            _controller.value.duration.inSeconds.toDouble();
                      }
                      setState(() {
                        scrubPosition = newPosition;
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      _controller.seekTo(
                          Duration(seconds: scrubPosition.toInt()));
                    },
                    child: VideoPlayer(_controller),
                  ),
                  //특정시점 표시를 위한 Positioned 요소 추가
                  for (Duration point in _specialPoints)
                    Positioned(
                        top: 665,
                        left: point.inSeconds.toDouble() *
                            MediaQuery.of(context).size.width /
                            _controller.value.duration.inSeconds,
                        child: Container(
                    width: 6,
                    height: 35,
                    color: Colors.white,
                  ),
                    ),
                  Positioned(
                    top: 450,
                    left: 0,
                    child: Column(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/back_effect.png',
                            width: 60,
                            height: 60,
                          ),
                          onPressed: () {
                            //배경화면 효과
                          },
                        ),
                        SizedBox(height: 5),
                        IconButton(
                          icon: Image.asset(
                            'assets/keypoint.png',
                            width: 60,
                            height: 60,
                          ),
                          onPressed: () {
                            //키포인트 보이기
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 670,
                    left: scrubPosition * MediaQuery
                        .of(context)
                        .size
                        .width / _controller.value.duration.inSeconds,
                    child: Container(
                      width: 8,
                      height: 30,
                      color: Colors.red,
                    ),
                  ),
                  for (Duration position in _thumbnailPositions)
                    Positioned(
                      top: 480,
                      left: position.inSeconds.toDouble() * MediaQuery
                          .of(context)
                          .size
                          .width / _controller.value.duration.inSeconds,
                      child: FutureBuilder<Uint8List>(
                        future: _getThumbnailImage(position),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done && snapshot.data != null) {
                            return Image.memory(snapshot.data!,
                                width: 40,
                                height: 30);
                          }
                          return Container();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 0.5),
          Positioned(
            top: 500,
            left: 200,
            child: Row(
              children: [
                SizedBox(width: 15),
                Text(
                  _formatDuration(Duration(seconds: scrubPosition.toInt())),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 100),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    _controller.play();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause, color: Colors.white),
                  onPressed: () {
                    _controller.pause();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<Uint8List> _getThumbnailImage(Duration position) async {
    Uint8List? thumbnailBytes = await VideoThumbnail.thumbnailData(
      video: _controller.dataSource,
      imageFormat: ImageFormat.PNG,
      timeMs: position.inMilliseconds,
    );

    return thumbnailBytes ?? Uint8List(0);
  }
}
