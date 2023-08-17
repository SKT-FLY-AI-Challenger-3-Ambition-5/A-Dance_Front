import 'package:a_dance/pages/a-dance_mypage.dart';
import 'package:a_dance/pages/select_song.dart';
import 'package:flutter/material.dart';

class A_Dance_Main extends StatelessWidget {
  const A_Dance_Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E4EE),
      appBar: AppBar(
        title: Text('에이단ㅡ스'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                height: 250,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Transform.translate(
                      offset: Offset(-25, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image(
                            image: AssetImage('images/adot-char2.gif'),
                            height: 180,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Select_Song()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              '연습하러가기',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '내 최고 점수',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '999',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '최근 플레이 곡',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'images/new_jeans.png',
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ClipOval(
                                  child: Image.asset(
                                    'images/new_jeans.png',
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ClipOval(
                                  child: Image.asset(
                                    'images/new_jeans.png',
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                '마이 페이지로 이동',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '인기 트렌드',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.refresh),
                        ],
                      ),
                      Row(
                        children: [],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
