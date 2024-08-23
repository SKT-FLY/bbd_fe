import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:bbd_project_fe/user_provider.dart';
import 'package:provider/provider.dart';

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
                            child: CupertinoButton( // 예 버튼
                              onPressed: () { // 클릭 시 intend에 따른 페이지로 진입
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
                            child: CupertinoButton( // 아니오 버튼
                              onPressed: () { // 클릭 시 음성 페이지로 진입
                                context.go('/chat');  // ChatScreen으로 돌아감
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

  void _handleYes(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    String search = '';
    // resultCode에 따라 병원 타입 설정
    switch (resultCode) {
      case 1:
        context.go('/tmap', extra: {
          'searchKeyword': "이비인후과", // 병원 타입 전달
          'centerLat': 37.5665, // 적절한 위도 값을 설정
          'centerLon': 126.9780, // 적절한 경도 값을 설정
          'userId': userId, // 적절한 userId를 설정
        });
        break;
      case 2:
        navigateToTmap(context,"내과",userId);
        break;
        break;
      case 3:
        navigateToTmap(context,"재활의학과",userId);
        break;
      case 4:
        navigateToTmap(context,"안과",userId);
        break;
      case 5:
        navigateToTmap(context,"정형외과",userId);
        break;
      case 6:
        navigateToTmap(context,"비뇨기과",userId);
        break;
      case 7:
        navigateToTmap(context,"신경외과",userId);
        break;
      case 8:
        navigateToTmap(context,"병원",userId);
        break;
      case 9: //taxi
        break;
        return; // 아래의 코드 실행 방지
      case 10:
        context.go('/SmsListScreen');
        return; // 아래의 코드 실행 방지
      case 11: // today 띄우면서 음성재생
        context.go('/futureSchedule');
        return; // 아래의 코드 실행 방지
      case 12:
        context.go('/todaySchedule');
        return; // 아래의 코드 실행 방지
      case 13:
        context.go('/noAnswer');
        return; // 아래의 코드 실행 방지
      default:
        print('Unknown result: $resultCode');
        return; // 아래의 코드 실행 방지
    }
  }
  void navigateToTmap(BuildContext context, String search, int userId) {
    print(search);
    context.go('/tmap', extra: {
      'searchKeyword': search, // 병원 타입 전달
      'centerLat': 37.5665, // 적절한 위도 값을 설정
      'centerLon': 126.9780, // 적절한 경도 값을 설정
      'userId': userId, // 적절한 userId를 설정
    });
  }
}
