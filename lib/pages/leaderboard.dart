import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class LeaderboardItem {
  final String ranking;
  final String songranking;
  final String imagePath;
  final String title;
  final String songtitle;
  final String playcount;
  final String count;


  LeaderboardItem(this.ranking, this.songranking, this.imagePath, this.title, this.songtitle, this.playcount, this.count);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LeaderboardScreen(),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  final List<LeaderboardItem> leaderboardData = [
    LeaderboardItem('순위', '1위', 'assets/rank1.png', '제목', 'Hype Boy', '플레이 횟수', '42'),
    LeaderboardItem('순위', '2위', 'assets/rank2.png', '제목', '이브,프시케 ...', '플레이 횟수', '30'),
    LeaderboardItem('순위', '3위', 'assets/rank3.png', '제목', 'See Tinh', '플레이 횟수','15'),
    // ... 추가적인 아이템 데이터를 입력하세요
  ];

  LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded), label: '챗T'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/rabbit.png',
                height: 50,
              ),
              label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.face), label: '프렌즈'),
          const BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
        ],
      ),
      appBar: AppBar(
        title: Text('노래 인기 순위'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.keyboard_arrow_left), // 이미지 파일의 경로
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaderboardData[index].ranking,
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          leaderboardData[index].songranking,
                          style: TextStyle(fontSize: 25),
                        ),
                        CircleAvatar(
                          radius: 13,
                          backgroundImage: AssetImage(leaderboardData[index].imagePath),
                        ),
                      ],
                    )

                  ],

                ),
                SizedBox(width: 25),
                Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leaderboardData[index].title,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        leaderboardData[index].songtitle,
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                ),
                ),
                SizedBox(width: 25),
                Column(
                    children: [
                      Text(
                        leaderboardData[index].playcount,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        leaderboardData[index].count,
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                SizedBox(width: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
