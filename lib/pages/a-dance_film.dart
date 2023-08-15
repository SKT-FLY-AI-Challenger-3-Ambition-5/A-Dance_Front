import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class A_Dance_Film extends StatefulWidget {
  @override
  _A_Dance_Film_State createState() => _A_Dance_Film_State();
}

class _A_Dance_Film_State extends State<A_Dance_Film> {
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;
  List<dynamic>? _recognitions;
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    loadModel();
  }

  _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    _initializeCameraFuture = _cameraController!.initialize();

    setState(() {});
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
        "lite-model_movenet_singlepose_lightning_tflite_float16_4.tflite");
  }

  // void _processCameraImage(CameraImage image) async {
  //   final img.Image convertedImage = _convertCameraImage(image); 192, 127.5,
  //   127.5); // This size, mean and std might be model specific
  //
  //   var output = <dynamic>[];
  //   _interpreter!.run(input, output);
  //
  //   setState(() {
  //   _recognitions = output;
  //   });
  // }
  //
  // img.Image _convertCameraImage(CameraImage image) {
  //   // CameraImage를 img.Image로 변환하는 로직 추가
  //   // ...
  // }
  //
  // Uint8List _imageToByteListFloat32(
  //     img.Image image, int inputSize, double mean, double std) {
  //   // img.Image를 Float32List로 변환하는 로직 추가
  //   // ...
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카메라 화면'),
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
