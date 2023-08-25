import 'dart:convert';
import 'dart:math';

import 'package:a_dance/main.dart';
import 'package:a_dance/pages/songleaderboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

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

class ChartData {
  final String rank;
  final int count;

  ChartData(this.rank, this.count);
}

class Report extends StatefulWidget {
  final String title;
  final double score;
  final List<double> frame_score;

  Report({required this.title, required this.score, required this.frame_score});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late final int score;
  late final List<String> frame_rank;
  late final int badCount;
  late final int goodCount;
  late final int greatCount;

  Future<List<LeaderboardItem>> getLeaderboard() async {
    List<LeaderboardItem> fetchedItems = [];
    print('title = ${widget.title}');
    final Uri url = Uri.parse('$URL/api/get_leaderboard');
    final Map<String, dynamic> requestBody = {"title": widget.title, "num": 3};
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

  Color getColor(String rank) {
    switch (rank) {
      case 'Bad':
        return Colors.red;
      case 'Good':
        return Colors.yellow;
      case 'Great':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    score = widget.score.round().toInt();
    frame_rank = widget.frame_score.map((score) {
      if (score >= 0 && score < 30) {
        return 'Bad';
      } else if (score >= 30 && score < 60) {
        return 'Good';
      } else if (score >= 60 && score <= 100) {
        return 'Great';
      } else {
        return 'Unknown'; // 이 경우는 score 값이 주어진 범위 외의 값인 경우를 위한 것입니다.
      }
    }).toList();

    badCount = frame_rank.where((rank) => rank == 'Bad').length;
    goodCount = frame_rank.where((rank) => rank == 'Good').length;
    greatCount = frame_rank.where((rank) => rank == 'Great').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // 원하는 높이로 조절
        child: AppBar(
          leading: Icon(
            Icons.keyboard_arrow_left,
            size: 50,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                '정확도 분석 결과',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 35,
              ),
              onPressed: () {
                //icon 눌렀을 때 수행할 작업
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<LeaderboardItem>>(
          future: getLeaderboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            } else
              print('snapshot = ${snapshot.data}');
            print('snapshot length = ${snapshot.data?.length}');
            return Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 310,
                                  width: 310,
                                  child: SfCircularChart(
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: [
                                          ChartData('Bad', badCount),
                                          ChartData('Good', goodCount),
                                          ChartData('Great', greatCount),
                                        ],
                                        xValueMapper: (ChartData data, _) =>
                                            data.rank,
                                        yValueMapper: (ChartData data, _) =>
                                            data.count,
                                        pointColorMapper: (ChartData data, _) =>
                                            getColor(data.rank),
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                        ),
                                        dataLabelMapper: (ChartData data, _) =>
                                            '${data.rank} ${data.count}',
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('총 점수'),
                                    Text(
                                      '${score}점',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '전체 사용자 중 0위에요',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeaderboardScreen(
                                                  title: widget.title,
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(30, 40),
                                  ),
                                  child: Text('이 곡의 리더보드 >',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].ranking,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data![index].playerranking,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      snapshot.data![index].imagePath),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    snapshot.data![index].playername,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].bestscore,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data![index].playerbestscore,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF3F3FFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: Size(330, 60),
                          ),
                          child: Text("리포트 보러가기",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
