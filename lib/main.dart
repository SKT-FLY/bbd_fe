
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/map_list/tmap.dart';
import 'screen/chat_screen.dart';
import 'screen/summary/message_summary_normal.dart';
import 'screen/summary/summary_result_normal.dart';
import 'screen/summary/summary_result_to_calendar.dart';
import 'screen/loading_screen.dart';
import 'screen/map_list/calling_screen.dart';
import 'router.dart';
import 'screen/calendar/monthly_calendar.dart';
import 'screen/calendar/today_calendar.dart';
import 'screen/summary/sms_received_screen.dart';


import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner:false,
      title: 'Flutter Cupertino Demo',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
  //@override
  //Widget build(BuildContext context) {
    //return CupertinoApp(
      //debugShowCheckedModeBanner: false,
      ///title: 'Flutter Cupertino Demo',
     // theme: const CupertinoThemeData(
       // primaryColor: CupertinoColors.activeOrange,
     // ),
     // home: ChatScreen(), // Screen()을 호출하여 홈 화면으로 설정
   // );
 // }
//}