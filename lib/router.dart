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
import 'screen/yes_no_screen.dart';
import 'screen/user_id_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const UserSelectionScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final int userId = state.extra as int;
        return ChatScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/start_calling',
      builder: (context, state) => const Calling_Screen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) {
        final bool goToSummaryPage1 = state.extra as bool? ?? false;
        return LoadingScreen(goToSummaryPage1: goToSummaryPage1);
      },
    ),
    GoRoute(
      path: '/start-message-summary',
      builder: (context, state) {
        final String messageText = state.extra as String;
        return SummaryScreen(text: messageText);
      },
    ),
    GoRoute(
      path: '/summary-result-normal',
      builder: (context, state) {
        final String messageText = state.extra as String;
        return SummaryResultScreen_normal(text: messageText);
      },
    ),
    GoRoute(
      path: '/summary-result-calendar',
      builder: (context, state) {
        final Map<String, String> data = state.extra as Map<String, String>? ?? {};
        return SummaryResultToCalendar(
          date: data['date'] ?? '날짜 정보 없음',
          time: data['time'] ?? '시간 정보 없음',
          content: data['content'] ?? '내용 정보 없음',
        );
      },
    ),
    GoRoute(
      path: '/monthly-calendar',
      builder: (context, state) {
        final int userId = state.extra as int;
        return ScheduleMonthlyScreen(
          userId: userId, // `userId`를 월간 캘린더 화면으로 전달
        );
      },
    ),
    GoRoute(
      path: '/daily-schedule',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final DateTime selectedDate = extra['selectedDate'];
        final int userId = extra['userId'];
        return ScheduleDailyScreen(
          selectedDate: selectedDate,
          userId: userId,
        );
      },
    ),
    GoRoute(
      path: '/smsListScreen',
      builder: (context, state) => SmsListScreen(),
    ),
    GoRoute(
      path: '/tmap',
      builder: (context, state) => const TmapScreen(),
    ),
    GoRoute(
      path: '/calling-screen',
      builder: (context, state) => const Calling_Screen(),
    ),
    GoRoute(
      path: '/yesno',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final String message = extra['message'];
        final int resultCode = extra['resultCode'];
        final int userId = extra['userId'];
        return YesNoScreen(message: message, resultCode: resultCode, userId: userId);
      },
    ),
  ],
);
