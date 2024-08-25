import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../setting/api_service.dart';
import '../../setting/location_provider.dart';

class YesNoScreen extends StatefulWidget {
  final String message;
  final int resultCode;
  final int userId;

  const YesNoScreen({
    super.key,
    required this.message,
    required this.resultCode,
    required this.userId,
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
  _YesNoScreenState createState() => _YesNoScreenState();
}

class _YesNoScreenState extends State<YesNoScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 이 메서드는 상태가 변경되거나 의존성이 변경될 때 호출됩니다.
    print("YesNoScreen dependencies changed.");
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
                            widget.message,
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
    print("Handling YES : " + widget.resultCode.toString());
    switch (widget.resultCode) {
      case 1:
        navigateToTmap(context, "이비인후과", widget.userId);
        break;
      case 2:
        navigateToTmap(context, "내과", widget.userId);
        break;
      case 3:
        navigateToTmap(context, "재활의학과", widget.userId);
        break;
      case 4:
        navigateToTmap(context, "안과", widget.userId);
        break;
      case 5:
        navigateToTmap(context, "정형외과", widget.userId);
        break;
      case 6:
        navigateToTmap(context, "비뇨기과", widget.userId);
        break;
      case 7:
        navigateToTmap(context, "신경외과", widget.userId);
        break;
      case 8:
        navigateToTmap(context, "병원", widget.userId);
        break;
      case 9: // 택시 api 호출
        try {
          final locationProvider = Provider.of<LocationProvider>(context, listen: false);

          if (locationProvider.isLocationPermissionGranted) {
            final position = locationProvider.currentPosition;

            if (position != null) {
              final apiService = ApiService();
              final taxiData = await apiService.fetchTaxiSearch(
                userId: widget.userId,
                latitude: position.latitude,
                longitude: position.longitude,
              );

              context.push('/taxi-search', extra: taxiData);
            } else {
              print('Failed to retrieve location');
            }
          } else {
            print('Location permission not granted');
          }
        } catch (e) {
          print('Error during taxi API request: $e');
        }

        break;
      case 10:
        context.push('/SmsListScreen');
        break;
      case 11:
        context.push('/monthly-calendar');
        break;
      case 12: // 오늘의 일정 가져오기
        _fetchScheduleData(widget.userId, context);
        break;
      case 13:
        context.push('/noAnswer');
        break;
      default:
        print('Unknown result: ${widget.resultCode}');
        break;
    }
  }

  void navigateToTmap(BuildContext context, String search, int userId) {
    context.push('/tmap', extra: {
      'searchKeyword': search,
      'userId': userId,
    });
  }

  Future<Map<String, dynamic>> _fetchScheduleData(int userId, BuildContext context) async {
    final DateTime todayDate = DateTime.now();
    final String formattedDate = "${todayDate.year}-${todayDate.month.toString().padLeft(2, '0')}-${todayDate.day.toString().padLeft(2, '0')}";
    final apiService = ApiService();

    try {
      final response = await apiService.fetchSchedule(formattedDate, userId);
      context.push(
        '/daily-schedule-TTS',
        extra: {
          'selectedDate': todayDate,
          'data': response,
        },
      );
      return response;
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      return {'error': '예외 발생', 'exception': e.toString()};
    }
  }
}
