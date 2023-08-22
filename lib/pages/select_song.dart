import 'dart:io';

import 'package:a_dance/pages/a-dance_film.dart';
import 'package:a_dance/pages/a-dance_main.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<String> downloadVideo(String videoId) async {
  final yt = YoutubeExplode();
  final manifest = await yt.videos.streamsClient.getManifest(videoId);
  // final streamInfo = manifest.muxed.withHighestBitrate();
  final streamInfo = manifest.muxed.last;

  var stream = yt.videos.streamsClient.get(streamInfo);
  final directory = await getTemporaryDirectory();

  final file = File('${directory.path}/downloaded.mp4');
  final fileStream = file.openWrite();

  await stream.pipe(fileStream); // 다운로드 및 파일에 저장
  fileStream.close();
  yt.close();

  print('file\'s path = ${file.path}');
  return file.path;
}

class Select_Song extends StatefulWidget {
  @override
  State<Select_Song> createState() => _Select_SongState();
}

class _Select_SongState extends State<Select_Song> {
  TextEditingController myController = TextEditingController();
  String inputText = '7HDeem-JaSY';
  String artist = "아티스트";
  String title = "제목";
  bool isLoading = false;
  String filepath = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => A_Dance_Main(),
                ),
              );
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

                        if (match != null) {
                          inputText = match.group(1) ?? '';
                          print('inputText = ${inputText}');
                          // String downloadUrl =
                          //     "http://64.176.226.248:8001/download/$inputText"; // 임시 Url
                          filepath = await downloadVideo(inputText);
                          print('filepath = $filepath');
                        }

                        setState(() {
                          isLoading = false; // 로딩 종료
                        });
                      },
                      icon: isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.search),
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
                  child: Image.network(
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                A_Dance_Film(videoPath: filepath)));
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
