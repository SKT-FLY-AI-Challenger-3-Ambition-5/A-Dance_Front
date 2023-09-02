import 'package:a_dance/pages/adot_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const URL = 'http://158.247.217.16:8000';
const FileServerURL = 'http://158.247.194.70:8080';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(Adot_Main());
}
