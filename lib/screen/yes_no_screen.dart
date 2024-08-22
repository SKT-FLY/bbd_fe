import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

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
    if (resultCode >= 1 && resultCode <= 9) {
      context.go('/tmap');
    } else {
      switch (resultCode) {
        case 10:
          context.go('/smsAnalysis');
          break;
        case 11:
          context.go('/futureSchedule');
          break;
        case 12:
          context.go('/todaySchedule');
          break;
        case 13:
          context.go('/noAnswer');
          break;
        default:
          print('Unknown result: $resultCode');
          break;
      }
    }
  }
}
