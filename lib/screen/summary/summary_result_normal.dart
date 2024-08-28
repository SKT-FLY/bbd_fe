import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SummaryResultScreen_normal extends StatefulWidget {
  final Map<String, dynamic> data;

  const SummaryResultScreen_normal({super.key, required this.data});

  @override
  _SummaryPage1State createState() => _SummaryPage1State();
}

class _SummaryPage1State extends State<SummaryResultScreen_normal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final String summaryText = widget.data['summary'] as String? ?? '요약 정보 없음';
    final String messageType = widget.data['message_type'] as String? ?? '';

    // 텍스트 박스의 배경색은 고정된 색상으로 설정
    final Color textBoxColor = CupertinoColors.white;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Spacer(flex: 2),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/summary.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 24,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white, // 상자의 기본 배경색을 하얀색으로 설정
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 노란색 바 추가
                          Container(
                            width: double.infinity,
                            height: screenHeight * 0.1, // 노란색 바의 높이를 화면 높이에 비례하게 설정
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6868), // 노란색 배경
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // 상단 모서리만 둥글게
                            ),
                            alignment: Alignment.topLeft, // 텍스트를 왼쪽 상단에 배치
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0), // 왼쪽과 위쪽에 여백 추가
                            child: Text(
                              messageType == "스미싱 문자" ? "스팸 문자" : messageType, // 조건에 따라 표시할 텍스트 변경
                              style: TextStyle(
                                fontSize: 37, // 텍스트 크기 설정
                                fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                color: CupertinoColors.black, // 텍스트 색상 설정
                              ),
                              textAlign: TextAlign.left, // 텍스트 정렬을 왼쪽으로 설정
                            ),
                          ),

                          // 실제 메시지를 담을 부분
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  summaryText,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.go('/chat');
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemYellow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.black.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
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
                ),
                Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
