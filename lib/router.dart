import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'screen/chat_screen.dart';
import 'screen/adot_call.dart';
import 'screen/loading_screen.dart';

import 'screen/message_summary.dart';
import 'screen/message_summary_screen.dart';
import 'screen/schedule_register_screen.dart';
import 'screen/summary_screen1.dart';
import 'screen/summary_screen2.dart';
import 'screen/tmap.dart';
import 'screen/warning_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => ChatScreen()),
    GoRoute(
        path: '/loading',
        builder: (context, state) => LoadingScreen()),

    GoRoute(
        path: '/tmap',
        builder: (context, state) => PhoneConnectionScreen()),
  ],
);