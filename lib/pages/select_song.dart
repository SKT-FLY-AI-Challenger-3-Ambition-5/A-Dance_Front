import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:a_dance/pages/a-dance_film.dart';
import 'package:a_dance/pages/a-dance_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadVideo(String youtubeUrl) async {
  final Dio dio = Dio();
  final response = await dio.get(
    "http://172.20.10.5:8000/download/", // url 변경 필요
    queryParameters: {"url": youtubeUrl},
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/downloaded.mp4');
  await file.writeAsBytes(response.data); // response.data가 여러개 올 예정

  print('file\'s path = ${file.path}');
  return file
      .path; // return 값에 file.path, song_info.title, song_info.artist 포함 예정
}

Future<Map<String, dynamic>> fetchDetails(String youtubeUrl) async {
  final response = await http.post(
    // Uri.parse('$URL/api/user_request_download_youtube'),
    Uri.parse('http://172.20.10.5:8001/download_youtube'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'youtube_url': youtubeUrl,
    }),
  );

  print('response.statusCode = ${response.statusCode}');
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);

    String title = responseData['title'];
    String artist = responseData['artist'];
    // String youtube_url = responseData['youtube_url'];
    List<dynamic> keypoints_tmp = responseData['keypoints'];

    return {
      'title': title,
      'artist': artist,
      // 'youtube_url': youtube_url,
      'keypoints': keypoints_tmp
    }; // 이 예에서는 전체 응답 데이터를 반환하였습니다.
  } else {
    throw Exception('Failed to load details');
  }
}

List<List<Offset>> decodeKeypoints(List<dynamic> keypoints_tmp) {
  List<dynamic> framesData = keypoints_tmp;
  return framesData
      .map((frameData) {
        return frameData
            .map((point) => Offset(point[0], point[1]))
            .toList()
            .cast<Offset>();
      })
      .toList()
      .cast<List<Offset>>();
}

class Select_Song extends StatefulWidget {
  @override
  State<Select_Song> createState() => _Select_SongState();
}

class _Select_SongState extends State<Select_Song> {
  TextEditingController myController = TextEditingController();
  String inputText = '';
  String artist = "아티스트";
  String title = "제목";
  bool isLoading = false;
  String filepath = '';
  late List<List<Offset>> allFramesKeypoints;

  @override
  void initState() {
    super.initState();
    _checkClipboard();
  }

  _checkClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text != null) {
      // 이 예제에서는 숫자를 찾는 정규 표현식을 사용합니다. 필요에 따라 수정하세요.
      RegExp regExp = RegExp(
          r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/shorts/)([^&?]+)');
      var match = regExp.firstMatch(clipboardData!.text!);
      if (match != null) {
        myController.text = match.group(0) ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE5E4EE),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "영상 선택",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => A_Dance_Main(),
                  ),
                  (route) => false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          labelText: '유튜브 주소 입력',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // 로딩 시작
                        });

                        RegExp regExp = RegExp(
                            r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/shorts/)([^&?]+)');
                        Match? match = regExp.firstMatch(myController.text);

                        if (match != null && isLoading == true) {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // 사용자가 다른 곳을 탭하더라도 팝업이 종료되지 않도록 합니다.
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('동영상을 다운로드 받고, 키포인트를 추출 중이에요!'),
                                actions: <Widget>[
                                  CircularProgressIndicator(), // 로딩 표시
                                ],
                              );
                            },
                          );

                          inputText = match.group(1) ?? '';
                          print('inputText = ${inputText}');
                          // String downloadUrl =
                          //     "http://64.176.226.248:8001/download/$inputText"; // 임시 Url
                          filepath = await downloadVideo(myController.text);

                          if (filepath.isNotEmpty) {
                            Map<String, dynamic> fetchData =
                                await fetchDetails(myController.text);
                            title = fetchData['title'];
                            artist = fetchData['artist'];
                            // tmp_list[2].toString(); // youtube_url
                            allFramesKeypoints =
                                decodeKeypoints(fetchData['keypoints']);
                          }

                          print('filepath = $filepath');
                          print('title = $title');
                          print('artist = $artist');
                          print('allFramesKeypoints = $allFramesKeypoints');
                        }

                        setState(() {
                          isLoading = false; // 로딩 종료
                        });

                        // 팝업 종료
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.download),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "선택된 영상",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ClipRect(
                  child: inputText.isEmpty
                      ? Container(
                          width: 320, // 네모 박스의 가로 크기
                          height: 180, // 네모 박스의 세로 크기
                          color: Colors.black,
                        )
                      : Image.network(
                          'https://img.youtube.com/vi/$inputText/mqdefault.jpg'),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: 480,
                  height: 208,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_outlined,
                              size: 48.0,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      artist,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF696969),
                                      ),
                                    ),
                                    Text(
                                      " 의",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_rounded,
                            ),
                            Expanded(
                              child: Text(
                                "원하는 노래의 유튜브 주소를 입력해주세요",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_rounded,
                            ),
                            Expanded(
                              child: Text(
                                "한 사람이 출연하는 영상이어야 해요",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: filepath.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => A_Dance_Film(
                                        videoPath: filepath,
                                        allFramesKeypoints: allFramesKeypoints,
                                      )));
                        },
                  child: Text(
                    '촬영하러 가기',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3F3FFF),
                      minimumSize: Size(280, 40)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
