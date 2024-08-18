import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // 이 부분 추가

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/tmap.dart';
import 'screen/chat_screen.dart';
import 'screen/message_summary.dart';
import 'screen/summary_screen1.dart';
import 'screen/summary_screen2.dart';
import 'screen/warning_screen.dart';
import 'screen/loading_screen.dart';
import 'screen/adot_call.dart';
import 'screen/monthly_calendar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 초기화
  runApp(MyApp());
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
      home: const ChatScreen(), // 앱 실행 시 처음 보여지는 화면을 ChatScreen으로 설정
    );
  }
}
