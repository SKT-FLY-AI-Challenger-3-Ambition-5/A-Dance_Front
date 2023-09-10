import 'package:a_dance/pages/select_song.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YoutubePage(),
    );
  }
}

class YoutubePage extends StatefulWidget {
  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _launchUrl('https://youtube.com');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Navigate to the next screen when the app resumes
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Select_Song()),
      );
    }
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('노래를 선택하세요'),
      ),
      body: const Center(
        child: Text(
            'You will be navigated to the Select Song screen after returning from the browser.'),
      ),
    );
  }
}
