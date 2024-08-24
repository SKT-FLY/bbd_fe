import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SummaryResultScreen_normal extends StatefulWidget {
  final Map<String, dynamic> data; // 데이터를 객체로 받습니다.

  const SummaryResultScreen_normal({super.key, required this.data});

  @override
  _SummaryPage1State createState() => _SummaryPage1State();
}

class _SummaryPage1State extends State<SummaryResultScreen_normal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // data['summary']만 추출하여 사용합니다.
    final String summaryText = widget.data['summary'] as String? ?? '요약 정보 없음';

    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // 비율 1:9(내부 1:14:2):2

                // 1 비율: 상단 요약글자
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '요약 결과',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 9 비율 내부 (1:14:2)
                Flexible(
                  flex: 9,
                  child: Column(
                    children: [
                      // 1 비율: 메세지 그림 컨테이너
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/summary.png', // 이미지 경로 설정
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),

                      // 14 비율: 메세지 내용 박스
                      Flexible(
                        flex: 14,
                        child: Center(
                          child: Container(
                            width: screenWidth * 0.9,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5EDED), // 연한 배경색
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.black.withOpacity(0.25),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SingleChildScrollView( // 긴 텍스트를 위한 스크롤 추가
                                child: Text(
                                  summaryText, // 요약 텍스트만 표시
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 2 비율: 요약하기 버튼
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: CupertinoButton(
                            color: CupertinoColors.activeBlue,
                            onPressed: () {
                              // 요약하기 버튼 클릭 시 수행할 동작
                            },
                            child: const Text(
                              '요약하기',
                              style: TextStyle(
                                fontSize: 20,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2 비율: 하단 중앙 홈 버튼
                Flexible(
                  flex: 2,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        context.go('/chat'); // 홈 버튼 클릭 시 홈 화면으로 이동
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemYellow,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.home,
                          color: CupertinoColors.black,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
