import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'screen/chat_screen.dart';
import 'screen/map_list/calling_screen.dart';
import 'screen/loading_screen.dart';

import 'screen/summary/start_summary_screen.dart';
import 'screen/summary/summary_result_normal.dart';
import 'screen/summary/summary_result_to_calendar.dart';
import 'screen/map_list/tmap.dart';

import 'screen/calendar/monthly_calendar.dart';
import 'screen/calendar/today_calendar.dart';
import 'screen/summary/sms_received_screen.dart';

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
      path: '/start_calling',
      builder: (context, state) => const Calling_Screen(),
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
      path: '/start-message-summary',
      builder: (context, state) {
        // state.extra에서 메시지 내용을 가져옵니다.
        final messageText = state.extra as String;
        // messageText를 SummaryScreen에 전달합니다.
        return SummaryScreen(text: messageText);
      },
    ),
    GoRoute(
      path: '/summary-result-normal',
      builder: (context, state){
        final messageText = state.extra as String;
        return SummaryResultScreen_normal(text:messageText);
      }
    ),
    GoRoute(
      path: '/summary-result-calendar',
      builder: (context, state) => const SummaryResultToCalendar(),
    ),
    GoRoute(
      path: '/monthly-calendar',
      builder: (context, state) => const ScheduleMonthlyScreen(),
    ),
    GoRoute(
      path: '/daily-schedule',
      builder: (context, state) {
        final selectedDate = state.extra as DateTime;
        return ScheduleDailyScreen(selectedDate: selectedDate);
      },
    ),
    GoRoute(
      path: '/smsListScreen',
      builder: (context, state) => SmsListScreen(),
    ),
    //GoRoute(
    //path: '/tmap',
    //builder: (context, state) {
    // 병원 데이터를 전달받아 사용
    //final hospitalData = state.extra as List<Map<String, String>>;
    //return TmapScreen(hospitalData: hospitalData);
    //},
    //),
    GoRoute(
      path: '/tmap',
      builder: (context, state) => const TmapScreen(),
    ),
    // Route for SMS Received Screen
    GoRoute(
      path: '/calling-screen',
      builder: (context, state) => const Calling_Screen(),
    ),
  ],
);