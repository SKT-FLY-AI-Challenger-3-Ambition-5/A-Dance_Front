import 'dart:convert';
import 'dart:math';

import 'package:a_dance/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class LeaderboardScreen extends StatefulWidget {
  late final String title;

  LeaderboardScreen({required String this.title});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  Future<List<LeaderboardItem>> getLeaderboard() async {
    List<LeaderboardItem> fetchedItems = [];
    print('title = ${widget.title}');
    final Uri url = Uri.parse('$URL/api/get_leaderboard');
    final Map<String, dynamic> requestBody = {"title": widget.title, "num": 10};
    final List<String> imagePaths = [
      'assets/rabbit.png',
      'assets/boy.png',
      'assets/girl.png'
    ]; // 이미지 경로 리스트

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(requestBody));
      print('response = ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('responseData = $responseData');
        List<dynamic> leaderboardResponse = responseData['leaderboard'];
        print('leaderboardResponse = $leaderboardResponse');

        fetchedItems = leaderboardResponse.asMap().entries.map((e) {
          int idx = e.key;
          var item = e.value;

          String randomImagePath =
              imagePaths[Random().nextInt(imagePaths.length)];

          return LeaderboardItem('순위', '${idx + 1}위', randomImagePath,
              item['username'], '최고점수', '${item['score']}점');
        }).toList();
      } else {
        print('Failed to send title: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending title: $error');
    }
    print('fetchedItems = ${fetchedItems}');
    return fetchedItems;
  }

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
                'images/a_dot_bottom_bar.png',
                height: 50,
              ),
              label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.face), label: '프렌즈'),
          const BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
        ],
      ),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              // GestureDetector 추가
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset('assets/back_icon.png'), // 이미지 파일의 경로
            ), // 이미지 파일의 경로
          ),
        ),
      ),
      body: FutureBuilder<List<LeaderboardItem>>(
        future: getLeaderboard(),
        builder: (BuildContext context,
            AsyncSnapshot<List<LeaderboardItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 데 오류가 발생했습니다.'));
          } else if (snapshot.hasData) {
            List<LeaderboardItem> leaderboardItems = snapshot.data!;
            return ListView.builder(
              itemCount: leaderboardItems.length,
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
                            leaderboardItems[index].ranking,
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            leaderboardItems[index].playerranking,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage(leaderboardItems[index].imagePath),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          leaderboardItems[index].playername,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leaderboardItems[index].bestscore,
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            leaderboardItems[index].playerbestscore,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('데이터가 없습니다.'));
          }
        },
      ),
    );
  }
}
