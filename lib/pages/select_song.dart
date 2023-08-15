import 'package:flutter/material.dart';
import 'package:youtube/youtube_thumbnail.dart';

class Select_Song extends StatefulWidget {
  @override
  State<Select_Song> createState() => _Select_SongState();
}

class _Select_SongState extends State<Select_Song> {
  TextEditingController myController = TextEditingController();
  String inputText = '7HDeem-JaSY';

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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '유튜브 주소 입력',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      inputText = myController.text.replaceRange(0, 32, '');
                    });
                  },
                  child: Text('update'),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "선택된 영상",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                ClipRect(
                  child: Image.network(
                    YoutubeThumbnail(
                      youtubeId: inputText,
                    ).mq(),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: 480,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
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
                                      "아티스트",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Color(0xFF696969),
                                      ),
                                    ),
                                    Text(
                                      " 의",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "노래 제목",
                                  style: TextStyle(
                                    fontSize: 24,
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
                          height: 8,
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.chat_rounded), label: '챗T'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'images/a_dot_bottom_bar.png',
                  height: 50,
                ),
                label: ''),
            const BottomNavigationBarItem(icon: Icon(Icons.face), label: '프렌즈'),
            const BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
          ],
        ),
      ),
    );
  }
}
