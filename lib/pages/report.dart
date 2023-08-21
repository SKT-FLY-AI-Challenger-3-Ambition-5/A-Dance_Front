import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ThreeSectionLayout(),
    );
  }
}

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

List<LeaderboardItem> leaderboardData = [
  LeaderboardItem('순위', '1위', 'assets/rabbit.png', '쁘띠공주민준', '최고점수', '980점'),
  LeaderboardItem('순위', '2위', 'assets/boy.png', '히다히다', '최고점수', '979점'),
  LeaderboardItem('순위', '3위', 'assets/girl.png', '째기', '최고점수', '390점'),
];

class ThreeSectionLayout extends StatelessWidget {
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
      body: Container(
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
                      SizedBox(
                          height: 310,
                          width: 310,
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              PieSeries<LeaderboardItem, String>(
                                dataSource: leaderboardData,
                                xValueMapper: (LeaderboardItem data, _) =>
                                    data.playername,
                                yValueMapper: (LeaderboardItem data, _) =>
                                    double.parse(data.playerbestscore
                                        .replaceAll('점', '')),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                ),
                              ),
                            ],
                            title: ChartTitle(
                              text: '전체 정확도 79%',
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '전체 사용자 중 0위에요',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              //버튼 눌렀을 때 수행할 작업
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
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leaderboardData[index].ranking,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                leaderboardData[index].playerranking,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage(leaderboardData[index].imagePath),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              leaderboardData[index].playername,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leaderboardData[index].bestscore,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                leaderboardData[index].playerbestscore,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
