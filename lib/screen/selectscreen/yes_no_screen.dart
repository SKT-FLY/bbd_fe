import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../setting/api_service.dart';
import '../../setting/location_provider.dart';

class YesNoScreen extends StatelessWidget {
  final String message;
  final int resultCode;
  final int userId; // userId 추가

  const YesNoScreen({
    super.key,
    required this.message,
    required this.resultCode,
    required this.userId, // userId 추가
  });

  factory YesNoScreen.fromGoRouter(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    return YesNoScreen(
      message: extra?['message'] ?? '메시지가 없습니다.',
      resultCode: extra?['resultCode'] ?? 0,
      userId: extra?['userId'] ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(flex: 4),
                Expanded(
                  flex: 75,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 32.0,
                              color: CupertinoColors.black,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              onPressed: () {
                                _handleYes(context);
                              },
                              color: CupertinoColors.activeGreen,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              borderRadius: BorderRadius.circular(12.0),
                              child: const Text(
                                '예',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              onPressed: () {
                                context.go('/chat');
                              },
                              color: CupertinoColors.destructiveRed,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              borderRadius: BorderRadius.circular(12.0),
                              child: const Text(
                                '아니오',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 45),
              ],
            ),
            Positioned(
              bottom: 16,
              left: (screenWidth - 100) / 2,
              child: GestureDetector(
                onTap: () {
                  context.go('/');
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemYellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.home,
                    color: CupertinoColors.black,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleYes(BuildContext context) async {
    print("Handling YES : " + resultCode.toString());
    switch (resultCode) {
      case 1:
        navigateToTmap(context, "이비인후과", userId);
        break;
      case 2:
        navigateToTmap(context, "내과", userId);
        break;
      case 3:
        navigateToTmap(context, "재활의학과", userId);
        break;
      case 4:
        navigateToTmap(context, "안과", userId);
        break;
      case 5:
        navigateToTmap(context, "정형외과", userId);
        break;
      case 6:
        navigateToTmap(context, "비뇨기과", userId);
        break;
      case 7:
        navigateToTmap(context, "신경외과", userId);
        break;
      case 8:
        navigateToTmap(context, "병원", userId);
        break;
      case 9: // 택시 api 호출
        try {
          // 위치 권한이 있는지 확인하기 위한 프로바이더 설정
          final locationProvider = Provider.of<LocationProvider>(context, listen: false);

          // 위치 권한 확인
          if (locationProvider.isLocationPermissionGranted) {
            // 위치 정보 가져오기
            final position = locationProvider.currentPosition;

            if (position != null) {
              // API 호출
              final apiService = ApiService();
              final taxiData = await apiService.fetchTaxiSearch(
                userId: userId,
                latitude: position.latitude,
                longitude: position.longitude,
              );

              // API 응답을 받고 나서 TmapTaxiSearchPage로 데이터를 전달하며 이동
              context.push('/taxi-search', extra: taxiData);
            } else {
              print('Failed to retrieve location');
              // 오류 처리: 위치 정보가 없을 경우 적절한 오류 메시지를 표시하거나 기본 위치를 설정할 수 있음
            }
          } else {
            print('Location permission not granted');
            // 오류 처리: 위치 권한이 없을 경우 사용자에게 알림 또는 다른 대체 작업 수행
          }
        } catch (e) {
          print('Error during taxi API request: $e');
          // 오류 처리: 예외 발생 시 처리할 내용을 작성
        }

        break;
      case 10:
        print("case 10");
        context.push('/SmsListScreen');
        break;
      case 11:
        print("case 11");
        context.push('/monthly-calendar');
        break;
      case 12: // 오늘의 일정 가져오기
        print("case 12");
        _fetchScheduleData(userId, context);
        break;
      case 13:
        print("case 13");
        context.push('/noAnswer');
        break;
      default:
        print('Unknown result: $resultCode');
        break;
    }
  }

  void navigateToTmap(BuildContext context, String search, int userId) {
    print(search);
    context.push('/tmap', extra: {
      'searchKeyword': search,
      'userId': userId,
    });
  }

  Future<Map<String, dynamic>> _fetchScheduleData(int userId, BuildContext context) async {
    final DateTime todayDate = DateTime.now();
    final String formattedDate = "${todayDate.year}-${todayDate.month.toString().padLeft(2, '0')}-${todayDate.day.toString().padLeft(2, '0')}";
    final apiService = ApiService();
    print(formattedDate);
    print("_fetchScheduleData 함수");

    try {
      final response = await apiService.fetchSchedule(formattedDate, userId);
      // GoRouter를 사용하여 '/daily-schedule-TTS' 경로로 이동, 데이터를 함께 전달
      context.push(
        '/daily-schedule-TTS',
        extra: {
          'selectedDate': todayDate,
          'data': response, // API 호출 결과를 전달
        },
      );
      return response; // API 호출 결과를 반환
    } catch (e) {
      // 예외 처리
      print('예외 발생: ${e.toString()}');
      return {'error': '예외 발생', 'exception': e.toString()}; // 예외를 반환
    }
  }
}
