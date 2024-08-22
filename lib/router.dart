import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'screen/chat_screen.dart';
import 'screen/map_list/calling_screen.dart';
import 'screen/loading_screen.dart';

import 'screen/summary/message_summary_normal.dart';
import 'screen/summary/summary_result_normal.dart';
import 'screen/summary/summary_result_to_calendar.dart';
import 'screen/map_list/tmap.dart';

import 'screen/calendar/monthly_calendar.dart';
import 'screen/calendar/today_calendar.dart';
import 'screen/summary/sms_received_screen.dart';
import 'screen/yes_no.dart';

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
      builder: (context, state) => const MessageSummaryScreen(),
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
    // Route for SMS Received Screen
    GoRoute(
      path: '/calling-screen',
      builder: (context, state) => const Calling_Screen(),
    ),
    GoRoute(
      path: '/yesno',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final message = extra?['message'] as String?;
        final resultCode = extra?['resultCode'] as int?;

        if (message == null || resultCode == null) {
          return const ChatScreen(); // 예외 처리: 잘못된 경우 ChatScreen으로 돌아감
        }

        return YesNoScreen(message: message, resultCode: resultCode);
      },
    ),
  ],
);