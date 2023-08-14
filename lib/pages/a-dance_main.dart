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
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          image: AssetImage('images/char1.png'),
                          height: 180,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
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
                            )
                          ],
                        ),
                      ],
                    )
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
