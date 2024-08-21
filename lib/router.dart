import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'screen/chat_screen.dart';
import 'screen/calling_screen.dart';
import 'screen/loading_screen.dart';
import 'screen/message_summary_normal.dart';
import 'screen/summary_result_normal.dart';
import 'screen/summary_result_to_calendar.dart';
import 'screen/tmap.dart';
import 'screen/monthly_calendar.dart';
import 'screen/today_calendar.dart';
import 'package:bbd_project_fe/screen/sms_received_screen.dart';

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
      builder: (context, state) => const StartMessageSummary(),
    ),
    GoRoute(
      path: '/summary-result-normal',
      builder: (context, state) => const SummaryResultScreen_normal(),
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
    GoRoute(
      path: '/calling-screen',
      builder: (context, state) => const Calling_Screen(),
    ),
  ],
);

