import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'screen/chat_screen.dart';
import 'screen/adot_call.dart';
import 'screen/loading_screen.dart';

import 'screen/message_summary.dart';
import 'screen/message_summary.dart';
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
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) {
        // 'extra'로 이동할 경로를 결정
        final bool goToSummaryPage1 = state.extra as bool? ?? false;
        return LoadingScreen(goToSummaryPage1: goToSummaryPage1);
      },
    ),
    GoRoute(
      path: '/message-summary',
      builder: (context, state) => const MessageSummaryScreen(),
    ),
    GoRoute(
      path: '/summary-screen1',
      builder: (context, state) => const SummaryPageScreen1(),
    ),
  ],
);
