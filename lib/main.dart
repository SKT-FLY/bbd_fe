
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
import 'router.dart';

void main() {
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