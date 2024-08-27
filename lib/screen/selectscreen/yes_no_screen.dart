import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart'; // 추가

import '../../setting/api_service.dart';
import '../../setting/location_provider.dart';

class YesNoScreen extends StatefulWidget {
  final String message;
  final int resultCode;
  final int userId;
  final String url; // URL 추가

  const YesNoScreen({
    super.key,
    required this.message,
    required this.resultCode,
    required this.userId,
    required this.url, // URL 추가
  });

  factory YesNoScreen.fromGoRouter(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    return YesNoScreen(
      message: extra?['message'] ?? '메시지가 없습니다.',
      resultCode: extra?['resultCode'] ?? 0,
      userId: extra?['userId'] ?? 0,
      url: extra?['url'] ?? '', // URL 추가 및 빈 문자열로 대체
    );
  }

  @override
  _YesNoScreenState createState() => _YesNoScreenState();
}

class _YesNoScreenState extends State<YesNoScreen> {
  late AudioPlayer _audioPlayer; // 오디오 플레이어 추가

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // 오디오 플레이어 초기화

    // URL이 비어 있지 않으면 오디오 재생
    if (widget.url.isNotEmpty) {
      _playAudioFromUrl(widget.url);
    }
  }

  Future<void> _playAudioFromUrl(String url) async {
    print("yes no가 받은" + url.toString());
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('Error playing audio from URL: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 오디오 플레이어 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Container(
                height: screenHeight * 0.6, // 흰색 상자의 높이를 조정
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 첫 번째 컨테이너: 텍스트
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "\n${widget.message}",
                        style: const TextStyle(
                          fontSize: 45.0,
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // 두 번째 컨테이너: 버튼들
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            onPressed: () {
                              _handleYes(context);
                            },
                            color: CupertinoColors.activeGreen,
                            padding: const EdgeInsets.symmetric(vertical: 22),
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
                            padding: const EdgeInsets.symmetric(vertical: 22),
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
                  ],
                ),
              ),
            ),
          ),
          // 하단에 홈화면으로 가는 플로팅 버튼 추가
          Positioned(
            bottom: 16,
            left: (screenWidth - 100) / 2, // 화면 가로축의 중앙에 배치
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
    );
  }

  Future<void> _handleYes(BuildContext context) async {
    print("Handling YES : ${widget.resultCode}");
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