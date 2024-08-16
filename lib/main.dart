
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tmap.dart';
import 'Screen/chat_screen.dart';
import 'screen/message_summary.dart';
import 'screen/summary_screen1.dart';
import 'screen/summary_screen2.dart';
import 'screen/warning_screen.dart';
import 'screen/loading_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner:false,
      title: 'Flutter Cupertino Demo',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: const LoadingScreen(), // 앱 실행 시 처음 보여지는 화면을 ChatScreen으로 설정
    );
  }
}
