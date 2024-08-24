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
      builder: (context, state) => ChatScreen(),
    ),
    GoRoute(
      path: '/calling-screen',
      builder: (context, state) {
        // state.extra가 null일 경우를 대비해 기본 값을 설정
        final String phoneNumber = (state.extra as String?) ?? '전화번호 없음'; // String?로 안전하게 캐스팅
        return Calling_Screen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(
      path: '/smsListScreen',
      builder: (context, state) => SmsListScreen(),
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
      builder: (context, state) {
        // state.extra를 Map<String, dynamic>으로 그대로 전달
        final data = state.extra as Map<String, dynamic>;
        return SummaryResultScreen_normal(data: data);
      },
    ),
    GoRoute(
      path: '/summary-result-calendar',
      builder: (context, state) {
        // state.extra가 null일 경우를 대비해 기본 Map을 제공
        final data = state.extra as Map<String, dynamic>? ?? {};

        return SummaryResultToCalendar(
          data: data,
        );
      },
    ),

    GoRoute(
      path: '/monthly-calendar',
      builder: (context, state) {
        return ScheduleMonthlyScreen(); // userId 파라미터 없이 생성자 호출
      },
    ),
    GoRoute(
      path: '/daily-schedule',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final DateTime selectedDate = extra['selectedDate'];
        return ScheduleDailyScreen(
          selectedDate: selectedDate, // userId 없이 생성자 호출
        );
      },
    ),
    GoRoute(
      path: '/daily-schedule-TTS',
      builder: (context, state) {
        final DateTime selectedDate = (state.extra as Map<String, dynamic>?)?['selectedDate'] ?? DateTime.now();
        final Map<String, dynamic>? extraData = (state.extra as Map<String, dynamic>?)?['data'];

        return ScheduleDailyScreen(
          selectedDate: selectedDate,
          extraData: extraData, // extraData를 전달
        );
      },
    ),

    GoRoute(
      path: '/tmap',
      builder: (context, state) {
        // state.extra가 null일 경우를 대비해 기본 Map을 제공
        final extra = state.extra as Map<String, dynamic>? ?? {};

        // 각 필드가 null일 경우 기본값을 제공
        final String hospitalType = extra['searchKeyword'] as String? ?? '병원';
        final int userId = extra['userId'] as int? ?? 0;
        final double centerLat = extra['centerLat'] as double? ?? 0.0;
        final double centerLon = extra['centerLon'] as double? ?? 0.0;
        print(extra['searchKeyword']);
        return TmapScreen(
          userId: userId,
          centerLat: centerLat,
          centerLon: centerLon,
          searchKeyword: hospitalType,
        );
      },
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