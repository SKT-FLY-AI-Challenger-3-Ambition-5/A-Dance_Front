import 'dart:convert';

import 'package:a_dance/main.dart';
import 'package:a_dance/pages/a-dance_mypage.dart';
import 'package:a_dance/pages/a-dance_youtube.dart';
import 'package:a_dance/pages/adot_main.dart';
import 'package:a_dance/pages/songleaderboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Future<String?> fetchData(String url_str) async {
  final url = Uri.parse(url_str);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return null; // Return null if the request failed
  }
}

Future<List<String?>> fetchVideoId(String searchTerm) async {
  final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchTerm&key=AIzaSyDgkHTDhrsOczTCQMsNRfG9JZKQQI01gRI&type=video&maxResults=1');
  print('url = $url');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print('data = $data');
    if (data['items'].isNotEmpty) {
      return [
        data['items'][0]['id']['videoId'],
        data['items'][0]['snippet']['title']
      ];
    }
  }

  return [
    null,
    null
  ]; // Return two null values if the request failed or data['items'] is empty
}

Future<List<String?>> getScore(String title) async {
  try {
    final url = '$URL/api/get_leaderboard'; // Set your URL
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'title': title,
      'num': 1,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final leaderboard = responseData['leaderboard'];
      if (leaderboard != null && leaderboard.isNotEmpty) {
        final username = leaderboard[0]['username'];
        final score = leaderboard[0]['score'];
        return [username, score.toString()]; // Convert score to string
      }
      print('Error: Empty leaderboard');
      return [
        'User1',
        '80'
      ]; // Return an error message in the list if leaderboard is empty
    } else {
      print('Error: HTTP ${response.statusCode}');
      return [
        'User1',
        '80'
      ]; // Return an error message in the list for non-200 responses
    }
  } catch (e) {
    print('Error fetching score: $e');
    return [
      'User1',
      '80'
    ]; // Return an error message in the list for exceptions
  }
}

Future<List<String?>> fetchMulti(String url_str) async {
  String? Data = await fetchData(url_str);

  if (Data == null) {
    return [
      null,
      null,
      null,
      null
    ]; // Return four null values if the request failed
  }

  List<dynamic> hotContents = jsonDecode(Data)['hot_contents'];
  print('hotContents = $hotContents');

  String title1 = hotContents[0]['title'];
  String title2 = hotContents[1]['title'];
  print('title1 = $title1');

  List<String?> video1 = await fetchVideoId(title1);
  print('video1 = $video1');
  List<String?> video2 = await fetchVideoId(title2);
  print('video2 = $video2');

  String? video1_id = video1[0];
  String? video1_title = video1[1];

  String? video2_id = video2[0];
  String? video2_title = video2[1];

  List<String?> video1_top = await getScore(title1);
  List<String?> video2_top = await getScore(title2);

  String? video1_top_username = video1_top[0];
  String? video1_top_score = video1_top[1];

  String? video2_top_username = video2_top[0];
  String? video2_top_score = video2_top[1];

  return [
    video1_id,
    video1_title,
    video2_id,
    video2_title,
    video1_top_username,
    video1_top_score,
    video2_top_username,
    video2_top_score
  ]; // Return the results as a list
}

class A_Dance_Main extends StatelessWidget {
  const A_Dance_Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E4EE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '에이단ㅡ스',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Adot_Main()),
                (route) => false);
          },
        ),
        toolbarHeight: 60.0,
      ),
      body: FutureBuilder<List<dynamic>>(
          future: fetchMulti('$URL/api/get_hot_contents/2'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터가 아직 로드되지 않았을 때 로딩 인디케이터 표시
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // 데이터 로드 완료. 이곳에서 응답 데이터를 사용하여 위젯을 렌더링.
              final responseData = snapshot.data;

              String? video1_id = responseData?[0];
              String? video1_title = responseData?[1];
              if (video1_title != null && video1_title!.length > 20) {
                video1_title = video1_title.substring(0, 17) + "...";
              }

              String? video2_id = responseData?[2];
              String? video2_title = responseData?[3];
              if (video2_title != null && video2_title!.length > 20) {
                video2_title = video2_title.substring(0, 17) + "...";
              }

              String? video1_top_username = responseData?[4];
              String? video1_top_score = responseData?[5];
              String? video2_top_username = responseData?[6];
              String? video2_top_score = responseData?[7];

              print('video1 = ${video1_top_username}');

              if (video1_id == null &&
                  video1_title == null &&
                  video2_id == null &&
                  video2_title == null &&
                  video1_top_username == null &&
                  video1_top_score == null &&
                  video2_top_username == null &&
                  video2_top_score == null) {
                video1_id = 'VOC83aZy_NI';
                video1_title = '로딩 실패';
                video2_id = 'VOC83aZy_NI';
                video2_title = '로딩 실패';
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        height: 270,
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
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WebViewApp()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF3F3FFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // 버튼 모서리를 둥글게 만듦
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: const Text(
                                      ' 연습하러가기 ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Inter',
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
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '   81',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 26,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '최근 플레이 곡',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      children: [
                                        RecentPlayedSong(
                                            img: 'images/new_jeans.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RecentPlayedSong(
                                            img: 'images/aespa.jpeg'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RecentPlayedSong(
                                            img: 'images/lesserafim.jpeg'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
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
                                        backgroundColor: Color(0xFF3F3FFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20), // 버튼 모서리를 둥글게 만듦
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20),
                                      ),
                                      child: const Text(
                                        '마이 페이지로 이동',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Inter',
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        height: 220,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '인기 트렌드',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.volume_mute),
                                      Icon(Icons.refresh),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String youtubeUrl =
                                                "https://www.youtube.com/watch?v=$video1_id";
                                            if (await canLaunch(youtubeUrl)) {
                                              await launch(youtubeUrl,
                                                  forceSafariVC: false,
                                                  forceWebView: false);
                                            } else {
                                              throw 'Could not launch $youtubeUrl';
                                            }
                                          },
                                          child: YoutubePlayer(
                                            width: 150,
                                            controller: YoutubePlayerController(
                                              initialVideoId: '$video1_id',
                                              flags: const YoutubePlayerFlags(
                                                autoPlay: false,
                                                mute: true,
                                                hideControls: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('$video1_title'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String youtubeUrl =
                                                "https://www.youtube.com/watch?v=$video2_id";
                                            if (await canLaunch(youtubeUrl)) {
                                              await launch(youtubeUrl,
                                                  forceSafariVC: false,
                                                  forceWebView: false);
                                            } else {
                                              throw 'Could not launch $youtubeUrl';
                                            }
                                          },
                                          child: YoutubePlayer(
                                            width: 150,
                                            controller: YoutubePlayerController(
                                              initialVideoId: '$video2_id',
                                              flags: const YoutubePlayerFlags(
                                                autoPlay: true,
                                                mute: true,
                                                hideControls: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('$video2_title')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '리더보드',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      LeaderBoardCell(
                                          img: 'images/char1.png',
                                          username: video1_top_username,
                                          score: video1_top_score),
                                      LeaderBoardCell(
                                          img: 'images/char3.png',
                                          username: video2_top_username,
                                          score: video2_top_score),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  // GestureDetector 또는 InkWell 사용 가능
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LeaderboardScreen(
                                                title: 'Do You Know Dr.Hong?',
                                              )), // 여기서 NewPage()는 새로운 위젯입니다.
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('더보기'),
                                      SizedBox(width: 30),
                                      Icon(Icons.arrow_forward),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class RecentPlayedSong extends StatelessWidget {
  final String img;

  const RecentPlayedSong({
    super.key,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        img,
        height: 40,
      ),
    );
  }
}

class LeaderBoardCell extends StatelessWidget {
  final String img;
  final String? username;
  final String? score;

  const LeaderBoardCell({
    super.key,
    required this.img,
    required this.username,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        height: 100,
        width: 170,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    img,
                    height: 80,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$username'),
                      Text(
                        '최고 점수',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
