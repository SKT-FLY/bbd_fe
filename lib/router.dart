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
    // GoRoute(
    //   path: '/calling-screen',
    //   builder: (context, state) => const Calling_Screen(),
    // ),
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
      builder: (context, state) {
        // 'extra'로 이동할 경로를 결정
        final bool goToSummaryPage1 = state.extra as bool? ?? false;
        return LoadingScreen(goToSummaryPage1: goToSummaryPage1);
      },
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
      builder: (context, state){
        final messageText = state.extra as String;
        return SummaryResultScreen_normal(text:messageText);
      }
    ),
    GoRoute(
      path: '/summary-result-calendar',
      builder: (context, state) {
        // state.extra가 null일 경우를 대비해 기본 Map을 제공
        final data = state.extra as Map<String,String>? ?? {};

        // 각 필드가 null일 경우 빈 문자열을 기본값으로 사용
        final String date = data['date'] ?? '날짜 정보 없음';
        final String time = data['time'] ?? '시간 정보 없음';
        final String content = data['content'] ?? '내용 정보 없음';

        return SummaryResultToCalendar(
          date: date,
          time: time,
          content: content,
        );
      },
    ),


    GoRoute(
      path: '/monthly-calendar',
      builder: (context, state) => const ScheduleMonthlyScreen(),
    ),
    GoRoute(
      path: '/daily-schedule',
      builder: (context, state) {
        final Map<String, Object> data = state.extra as Map<String, Object>;
        final DateTime selectedDate = data['selectedDate'] as DateTime;

        return ScheduleDailyScreen(
          selectedDate: selectedDate,
        );
      },
    ),

    GoRoute(
      path: '/tmap',
      builder: (context, state) {
        // state.extra가 null일 경우를 대비해 기본 Map을 제공
        final extra = state.extra as Map<String, dynamic>? ?? {};

        // 각 필드가 null일 경우 기본값을 제공
        final int userId = extra['userId'] as int? ?? 0;
        final double centerLat = extra['centerLat'] as double? ?? 0.0;
        final double centerLon = extra['centerLon'] as double? ?? 0.0;
        final String hospitalType = extra['hospitalType'] as String? ?? '병원 유형 없음';

        return TmapScreen(
          userId: userId,
          centerLat: centerLat,
          centerLon: centerLon,
          hospitalType: hospitalType,
        );
      },
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