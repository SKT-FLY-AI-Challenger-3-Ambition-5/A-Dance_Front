import 'dart:io';
import 'dart:math';

import 'package:a_dance/pages/a-dance_video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class A_Dance_Film extends StatefulWidget {
  final String videoPath;

  A_Dance_Film({required this.videoPath});

  @override
  _A_Dance_Film_State createState() => _A_Dance_Film_State();
}

class _A_Dance_Film_State extends State<A_Dance_Film> {
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;
  int countdownValue = 3;
  late AudioPlayer counter;
  bool isRecording = false;
  String? videoPath; // 녹화된 동영상의 경로를 저장합니다.
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    counter = AudioPlayer();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController?.addListener(_videoListener); // 리스너 추가
      });
  }

  _initializeCamera() async {
    final cameras = await availableCameras();

    // 전면 카메라를 찾습니다.
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first // 만약 전면 카메라가 없다면 기본 카메라를 사용합니다.
        );

    _cameraController = CameraController(
      frontCamera, // 후면 카메라를 사용하는 대신 전면 카메라를 사용합니다.
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeCameraFuture = _cameraController!.initialize();

    setState(() {});
  }

  void _videoListener() {
    if (_videoPlayerController?.value.position ==
        _videoPlayerController?.value.duration) {
      // 비디오 재생이 끝났을 때의 처리
      stopRecording();
      _videoPlayerController?.removeListener(_videoListener); // 리스너 제거
    }
  }

  Future<void> startCountdown() async {
    Future.delayed(Duration(seconds: 1), () async {
      if (countdownValue > 0) {
        setState(() {
          countdownValue--;
        });
        startCountdown();
      } else {
        await _cameraController?.startVideoRecording();
        await _videoPlayerController?.play();
      }
    });
  }

  Future<void> stopRecording() async {
    try {
      XFile videoFile = await _cameraController!.stopVideoRecording();
      videoPath = videoFile.path;
      print('Video Path: $videoPath'); // 경로 로그

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlaybackScreen(
                    videoPath: videoPath!,
                  )));
    } catch (e) {
      print('Error in stopRecording: $e'); // 오류 로그
    }
  }

  void _resetState() {
    // 카메라 초기화
    _initializeCamera();

    // 다른 상태 초기화 (예: countdownValue, isRecording 등)
    setState(() {
      countdownValue = 3;
      isRecording = false;
      videoPath = null;
    });

    _videoPlayerController?.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: 1.9,
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: Transform(
                        // 여기에 Transform 위젯을 추가합니다.
                        transform: Matrix4.identity()..scale(1.0, -1.0, 1.0),
                        alignment: Alignment.center,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),
                if (countdownValue > 0)
                  Center(
                    child: Text(
                      '$countdownValue',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                if (countdownValue <= 0)
                  Center(
                    child: Text(
                      '',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                if (_videoPlayerController?.value.isInitialized ?? false)
                  Positioned(
                    top: 20, // 원하는 위쪽 패딩을 조정하세요
                    right: 20, // 원하는 오른쪽 패딩을 조정하세요
                    child: Opacity(
                      opacity: 0.6,
                      child: Container(
                        width: 150, // 원하는 너비를 설정하세요
                        height: 250, // 16:9 비율에 따른 높이 (비디오의 종횡비에 따라 조절하세요)
                        child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: VideoPlayer(_videoPlayerController!),
                            )),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가로 방향 중앙 정렬
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue, // 새로고침 버튼의 배경색을 설정
            onPressed: _resetState,
            child: Icon(Icons.refresh), // 새로고침 아이콘
          ),
          SizedBox(width: 20), // 두 버튼 사이의 간격
          FloatingActionButton.large(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              if (isRecording) {
                // isRecording이 true일 때의 동작
                // stopRecording();
                _videoPlayerController?.pause();
              } else {
                // isRecording이 false일 때의 동작
                startCountdown();
                counter.play(AssetSource('songs/countdown.mp3'));
              }
              setState(() {
                isRecording = !isRecording; // isRecording 상태를 전환합니다.
              });
            },
            child: isRecording
                ? Image.asset(
                    'images/stop_btn.png') // isRecording이 true일 때의 이미지
                : Image.asset(
                    'images/record_btn.png'), // isRecording이 false일 때의 이미지
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.grey, // 뒤로 가기 버튼의 배경색을 설정
            onPressed: () {
              Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아갑니다.
            },
            child: Icon(Icons.arrow_back), // 뒤로 가기 아이콘
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    counter.dispose();
    super.dispose();
  }
}
