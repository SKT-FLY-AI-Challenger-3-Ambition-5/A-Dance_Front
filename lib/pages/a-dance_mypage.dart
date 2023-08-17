import 'package:flutter/material.dart';
import 'package:a_dance/pages/a-dance_main.dart';
import 'package:a_dance/pages/a-dance_setting.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFE5E4EE),
        appBar: AppBar(
          centerTitle: true,
          title: Text('마이페이지'),
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
          actions: <Widget>[
            Icon(Icons.notifications),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Setting(),
                  ),
                );
              },
              icon: Icon(Icons.settings_outlined),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: 360,
            height: 568,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  width: 320,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF3B4666),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'images/a_dot_bottom_bar.png',
                            height: 60,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "쁘띠공주민준",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.change_circle,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "대표곡",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hype Boy",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "최고점수",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "93.8",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          height: 1.0,
                          width: 300.0,
                          color: Color(0xFF7B8191),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.music_note_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                "플레이 곡 목록",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                "친구 목록",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  width: 320,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.volume_up_rounded,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("알림 사항"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 140,
                            height: 152,
                            decoration: BoxDecoration(
                              color: Color(0xFF6F6FFA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.queue_music_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Text(
                                    "플레이 곡수",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "121곡",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 152,
                            decoration: BoxDecoration(
                              color: Color(0xFF3F3FFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.sentiment_satisfied_alt_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Text(
                                    "대표곡",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Hype Boy",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 140,
                            height: 152,
                            decoration: BoxDecoration(
                              color: Color(0xFF5252FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.score_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Text(
                                    "평균 점수",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "90.6점",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 152,
                            decoration: BoxDecoration(
                              color: Color(0xFF343783),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.thumb_up_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Text(
                                    "최고 점수",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "95.8점",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
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
