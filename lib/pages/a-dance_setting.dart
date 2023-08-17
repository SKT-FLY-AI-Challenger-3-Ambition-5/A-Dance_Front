import 'package:flutter/material.dart';
import 'package:a_dance/pages/a-dance_mypage.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFE5E4EE),
        appBar: AppBar(
          centerTitle: true,
          title: Text('설정'),
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPage(),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 540,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "사용자 설정",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 340,
                    height: 160,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("개인 정보"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("서비스 연결"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("이용권"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "리더보드",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 340,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("노래 인기 순위"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("곡별 리더보드"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "앱 설정",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 340,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("일반"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("소리"),
                              Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "이용약관",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.black.withOpacity(0.3),
                              thickness: 1,
                            ),
                            Text(
                              "오픈소스 라이선스",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "개인정보 처리방침",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
