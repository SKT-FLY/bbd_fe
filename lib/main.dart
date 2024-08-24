import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// 설정 관련 파일
import 'package:bbd_project_fe/setting/location_provider.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:bbd_project_fe/setting/router.dart';

// 스크린 관련 파일
import 'screen/loading_screen.dart';
import 'screen/chat_screen.dart';
import 'screen/map_list/tmap_pois.dart';
import 'screen/map_list/calling_screen.dart';
import 'screen/summary/start_summary_screen.dart';
import 'screen/summary/summary_result_normal.dart';
import 'screen/summary/summary_result_to_calendar.dart';
import 'screen/calendar/monthly_calendar.dart';
import 'screen/calendar/today_calendar.dart';
import 'screen/summary/sms_received_screen.dart';


import 'package:bbd_project_fe/setting/location_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/map_list/tmap_pois.dart';
import 'screen/chat_screen.dart';
import 'screen/summary/start_summary_screen.dart';
import 'screen/summary/summary_result_normal.dart';
import 'screen/summary/summary_result_to_calendar.dart';
import 'screen/loading_screen.dart';
import 'screen/map_list/calling_screen.dart';
import 'setting/router.dart';
import 'screen/calendar/monthly_calendar.dart';
import 'screen/calendar/today_calendar.dart';
import 'screen/summary/sms_received_screen.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';


import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()), // 위치 제공자 등록
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.checkAndRequestLocationPermission(); // 앱 시작 시 권한 확인 및 위치 요청

    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
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
