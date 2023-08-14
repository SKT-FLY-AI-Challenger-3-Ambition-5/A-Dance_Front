import 'package:a_dance/pages/a-dance_main.dart';
import 'package:flutter/material.dart';

class Adot_Main extends StatelessWidget {
  const Adot_Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  _Main createState() => _Main();
}

class _Main extends State<Main> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스

  // 각 탭에 해당하는 위젯들
  final List<Widget> _widgetOptions = <Widget>[
    const Main1(),
    const Main2(),
    const Main3(),
    const Main4(),
    const Main5(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _widgetOptions.elementAt(_selectedIndex), // 선택된 탭에 해당하는 위젯을 보여줍니다.
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
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        selectedIconTheme: const IconThemeData(size: 20), // 선택된 아이콘 크기
        unselectedIconTheme: const IconThemeData(size: 20), // 선택되지 않은 아이콘 크기
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class Main1 extends StatelessWidget {
  const Main1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB9DCF9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Image(
                image: AssetImage('images/adot_logo.png'),
                height: 30,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '오늘의 Best 곡은\nNewJeans의\nHypeBoy에요♫',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Image(
                    image: AssetImage('images/char3.png'),
                    height: 170,
                  )
                ],
              ),
              // Add your other UI components like buttons, icons, text fields, etc.
              Transform.translate(
                offset: const Offset(0, -30),
                child: Column(
                  children: [
                    Container(
                      height: 125,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => A_Dance_Main()));
                              },
                              style: ButtonStyle(),
                              child: const Text('에이단스 하러가기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: const Column(
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage('images/main_card1.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: const Column(
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage('images/main_card2.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Main2 extends StatelessWidget {
  const Main2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Image(image: AssetImage('images/main2.png')),
    );
  }
}

class Main3 extends StatelessWidget {
  const Main3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Image(image: AssetImage('images/main3.png')),
    );
  }
}

class Main4 extends StatelessWidget {
  const Main4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Image(image: AssetImage('images/main4.png')),
    );
  }
}

class Main5 extends StatelessWidget {
  const Main5({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Image(image: AssetImage('images/main5.png')),
    );
  }
}
