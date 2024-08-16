/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'message_summary.dart';
import 'summary_page1.dart';


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
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: const ChatScreen(), // 앱 실행 시 처음 보여지는 화면을 ChatScreen으로 설정
    );
  }
}
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'message_summary.dart';
import 'summary_page1.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: SummaryPage1(), // 이 부분을 SummaryPage1으로 지정
    );
  }
}