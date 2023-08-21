import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(ReportApp());
}

class ReportApp extends StatelessWidget {
  final List<double> data;
  ReportApp()
      : data = [
          80,
          85,
          90,
          88,
          95,
          92,
          45,
          47,
          78,
          78,
          78,
          89,
          90
        ]; // 정확도 그래프 데이터

  int get dldl => data.length; // 계산된 getter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFE5E4EE), // 회색 배경
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50), // Size Box 높이

              // 흰색 컨테이너
              Container(
                height: 2200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도 조절
                      offset: Offset(-1, -4), // (x, y) 그림자의 오프셋 조절
                      blurRadius: 5, // 그림자의 흐림 정도 조절
                    ),
                  ],
                ),
                //padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 1,
                        ),
                        Icon(Icons.arrow_back_ios_new_rounded),
                        SizedBox(
                          width: 70,
                        ),
                        Text(
                          "개인 리포트",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Icon(Icons.more_vert_rounded),
                        SizedBox(width: 1),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '사용자 닉네임',
                            style: TextStyle(
                              color: Color(0xFF9EA3B1),
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: ' 님의\n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: '에이단ㅡ스',
                            style: TextStyle(
                              color: Color(0xFF5252FF),
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: ' 분석 리포트',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '정확도 그래프',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF6F6FFA),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '정확도(%)',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 300,
                            height: 150,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 100,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  drawHorizontalLine: true,
                                ),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      left: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 158, 158, 158)),
                                      bottom: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 158, 158, 158)),
                                    )),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(10, (index) {
                                      return FlSpot(
                                          index.toDouble(), data[index]);
                                    }),
                                    isCurved: true,
                                    color: Color(0xFF6F6FFA),
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 120,
                      padding: const EdgeInsets.only(top: 11, bottom: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //평균 정확도
                          Container(
                            width: 160,
                            height: 110,
                            padding: EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // 그림자 색상 및 투명도 조절
                                  offset: Offset(1, 2), // (x, y) 그림자의 오프셋 조절
                                  blurRadius: 5, // 그림자의 흐림 정도 조절
                                ),
                              ],
                            ),
                            child: Column(children: [
                              Row(
                                children: [
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.insert_chart_rounded,
                                    color: Color(0xFF5252FF),
                                  ),
                                  SizedBox(width: 5), // 아이콘과 텍스트 간격
                                  Text(
                                    '평균 정확도',
                                    style: TextStyle(
                                      color: Color(0xFFA0AEC0),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 25,
                                    child: Text(
                                      '72%',
                                      style: TextStyle(
                                        color: Color(0xFF2D3748),
                                        fontSize: 23,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 15,
                                    child: Text(
                                      '+12%',
                                      style: TextStyle(
                                        color: Color(0xFF48BB78),
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 72,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF5252FF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            2.5), // 왼쪽 끝을 라운드 처리
                                        bottomLeft: Radius.circular(2.5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 28,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA0AEC0),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            2.5), // 오른쪽 끝을 라운드 처리
                                        bottomRight: Radius.circular(2.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 160,
                            height: 110,
                            padding: EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // 그림자 색상 및 투명도 조절
                                  offset: Offset(1, 2), // (x, y) 그림자의 오프셋 조절
                                  blurRadius: 5, // 그림자의 흐림 정도 조절
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.library_music_rounded,
                                      color: Color(0xFF5252FF),
                                    ),
                                    SizedBox(width: 5), // 아이콘과 텍스트 간격
                                    Text(
                                      '리듬감',
                                      style: TextStyle(
                                        color: Color(0xFFA0AEC0),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    SizedBox(
                                      width: 50,
                                      height: 25,
                                      child: Text(
                                        '86%',
                                        style: TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontSize: 23,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 15,
                                      child: Text(
                                        '- 8%',
                                        style: TextStyle(
                                          color: Color(0xFFE53E3E),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 86,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF5252FF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              2.5), // 왼쪽 끝을 라운드 처리
                                          bottomLeft: Radius.circular(2.5),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 14,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA0AEC0),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              2.5), // 오른쪽 끝을 라운드 처리
                                          bottomRight: Radius.circular(2.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //정확도 결과 컨테이너
                    Container(
                      height: 1460,
                      decoration: BoxDecoration(
                        color: Color(0xFF5252FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // 그림자 색상 및 투명도 조절
                            offset: Offset(-1, -4), // (x, y) 그림자의 오프셋 조절
                            blurRadius: 5, // 그림자의 흐림 정도 조절
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                CupertinoIcons.sparkles,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "정확도가 낮은 부분을",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 40),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "조금만 더 연습해보세요!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 40)
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  elevation: 10, // 그림자의 깊이 조절
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFCFCFFB),
                                        Color(0xFFE7E7FF)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 160, minHeight: 48),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Icon(
                                            CupertinoIcons
                                                .hand_point_right_fill,
                                            color: Colors.amber),
                                        Text(
                                          " 0:03~0:06 ",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              elevation: 10, // 그림자의 깊이 조절
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 40),
                            ),
                            child: Row(
                              children: [
                                Image.asset("images/example.png", width: 100),
                                SizedBox(width: 30),
                                SizedBox(
                                  width: 150,
                                  height: 70,
                                  child: Text(
                                    '음악과 박자를 맞추어 보세요!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  elevation: 10, // 그림자의 깊이 조절
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFCFCFFB),
                                        Color(0xFFE7E7FF)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 160, minHeight: 48),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Icon(
                                            CupertinoIcons
                                                .hand_point_right_fill,
                                            color: Colors.amber),
                                        Text(
                                          " 0:12~0:15 ",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              elevation: 10, // 그림자의 깊이 조절
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 40),
                            ),
                            child: Row(
                              children: [
                                Image.asset("images/example.png", width: 100),
                                SizedBox(width: 30),
                                SizedBox(
                                  width: 150,
                                  // height: 70,
                                  child: Text(
                                    '왼팔의 움직임에 조금 더 주의를 기울여 보세요!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  elevation: 10, // 그림자의 깊이 조절
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFCFCFFB),
                                        Color(0xFFE7E7FF)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 160, minHeight: 48),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Icon(
                                            CupertinoIcons
                                                .hand_point_right_fill,
                                            color: Colors.amber),
                                        Text(
                                          " 0:12~0:15 ",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              elevation: 10, // 그림자의 깊이 조절
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 40),
                            ),
                            child: Row(
                              children: [
                                Image.asset("images/example.png", width: 100),
                                SizedBox(width: 30),
                                SizedBox(
                                  width: 150,
                                  // height: 70,
                                  child: Text(
                                    '다리의 움직임에 조금 더 주의를 기울여 보세요!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'A.dance Evaluation Report\n',
                                  style: TextStyle(
                                    color: Color(0xFF9EA3B1),
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Produced by 에이닷',
                                  style: TextStyle(
                                    color: Color(0xFF9EA3B1),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
