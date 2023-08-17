import 'package:flutter/material.dart';

class LeaderboardItem {
  final String ranking;
  final String playerranking;
  final String imagePath;
  final String playername;
  final String bestscore;
  final String playerbestscore;

  LeaderboardItem(this.ranking, this.playerranking, this.imagePath,
      this.playername, this.bestscore, this.playerbestscore);
}

class MyBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LeaderboardScreen(),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  final List<LeaderboardItem> leaderboardData = [
    LeaderboardItem('순위', '1위', 'assets/rabbit.png', '쁘띠공주민준', '최고점수', '980점'),
    LeaderboardItem('순위', '2위', 'assets/boy.png', '히다히다', '최고점수', '979점'),
    LeaderboardItem('순위', '3위', 'assets/girl.png', '째기', '최고점수', '390점'),
    // ... 추가적인 아이템 데이터를 입력하세요
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hype Boy - New Jeans'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Image.asset('assets/back_icon.png'), // 이미지 파일의 경로
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaderboardData[index].ranking,
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      leaderboardData[index].playerranking,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(leaderboardData[index].imagePath),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    leaderboardData[index].playername,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaderboardData[index].bestscore,
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      leaderboardData[index].playerbestscore,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(width: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
