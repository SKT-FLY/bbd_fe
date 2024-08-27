import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../data/gpsScreen.dart';
import '../screen/adot.dart';
import '../screen/calendar/guardian_calendar_daily.dart';
import '../screen/calendar/guardian_calendar_monthly.dart';
import '../screen/chat_screen.dart';
import '../screen/loading_screen.dart';
import 'package:bbd_project_fe/screen/chat_screen.dart';

import '../screen/map_list/tmap_taxi.dart';
import '../screen/summary/start_summary_screen.dart';
import '../screen/summary/summary_result_normal.dart';
import '../screen/summary/summary_result_to_calendar.dart';
import '../screen/summary/sms_received_screen.dart';

import '../screen/calendar/monthly_calendar.dart';
import '../screen/calendar/today_calendar.dart';

import '../user_id_screen.dart';
import '../screen/map_list/calling_screen.dart';
import '../screen/map_list/tmap_pois.dart';

import '../screen/selectscreen/yes_no_screen.dart';
//builder: (context, state) => const UserSelectionScreen(),

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AdotScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
    GoRoute(
      path: '/calling-screen-pois',
      builder: (context, state) {
        // state.extra가 Map<String, String> 타입인지 확인하고 기본값 제공
        final Map<String, String> extraData = state.extra != null && state.extra is Map<String, String>
            ? state.extra as Map<String, String>
            : {'phoneNumber': '전화번호 없음', 'hospitalName': '병원 이름 없음'};

        final String phoneNumber = extraData['phoneNumber'] ?? '전화번호 없음';
        final String hospitalName = extraData['hospitalName'] ?? '병원 이름 없음';

        return CallingScreen(
          phoneNumber: phoneNumber,
          displayName: hospitalName, // 병원 이름을 displayName으로 전달
        );
      },
    ),


    GoRoute(
      path: '/calling-screen-taxi',
      builder: (context, state) {
        // state.extra가 Map<String, String> 타입인지 확인하고 기본값 제공
        final Map<String, String> extraData = state.extra != null && state.extra is Map<String, String>
            ? state.extra as Map<String, String>
            : {'phoneNumber': '전화번호 없음', 'taxiName': '택시 이름 없음'};

        final String phoneNumber = extraData['phoneNumber'] ?? '전화번호 없음';
        final String taxiName = extraData['taxiName'] ?? '택시 이름 없음';

        return CallingScreen(
          phoneNumber: phoneNumber,
          displayName: taxiName, // 택시 이름을 displayName으로 전달
        );
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
    ///// 보호자 달력 라우터final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
    //         final int userId = extra['guardianId'] as int;
    GoRoute(
      path: '/guardian-monthly-schedule',
      builder: (context, state) {
        return GuardianScheduleMonthlyScreen();
      },
    ),
    GoRoute(
      path: '/guardian-daily-schedule',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final DateTime selectedDate = extra['selectedDate'];
        final List<dynamic> events = extra['events']; // 전달된 일정 데이터를 받아옵니다.

        return GuardianScheduleDailyScreen(
          selectedDate: selectedDate,
          extraData: events, // 일정을 넘겨줍니다.
        );
      },
    ),


    ///// map 라우터
    GoRoute(
      path: '/daily-schedule',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final DateTime selectedDate = extra['selectedDate'];
        return ScheduleDailyScreen(
          selectedDate: selectedDate,
        );
      },
    ),
    GoRoute(
      path: '/daily-schedule-TTS',
      builder: (context, state) {
        final DateTime selectedDate = (state.extra as Map<String, dynamic>?)?['selectedDate'] ?? DateTime.now();
        final Map<String, dynamic>? extraData = (state.extra as Map<String, dynamic>?)?['extraData'];

        return ScheduleDailyScreen(
          selectedDate: selectedDate,
          extraData: extraData, // extraData를 전달
        );
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
        final Map<String, dynamic>? extraData = (state.extra as Map<String, dynamic>?)?['extraData'];

        return ScheduleDailyScreen(
          selectedDate: selectedDate,
          extraData: extraData, // extraData를 전달
        );
      },
    ),


    GoRoute(
      path: '/taxi-search',
      builder: (context, state) {
        final taxiData = state.extra as Map<String, dynamic>; // extra를 통해 데이터를 가져옴
        return TaxiSearchPage(taxiData: taxiData);
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
        final String url = extra['url'] as String; // URL을 추가로 받음
        print("router"+url.toString());
        return YesNoScreen(
          message: message,
          resultCode: resultCode,
          userId: userId,
          url: url, // URL을 YesNoScreen에 전달
        );
      },
    ),
  ],
);