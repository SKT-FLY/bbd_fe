import 'package:flutter/cupertino.dart';
import 'package:bbd_project_fe/setting/router.dart';
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
      debugShowCheckedModeBanner :false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Spacer(flex: 2),
                Expanded( // 이미지 공간
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Image.asset(
                        'assets/images/summary.png', // 이미지 경로 설정
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex:1),
                Expanded( // 텍스트 박스 공간
                  flex: 24,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EDED), // 연한 배경색
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.3),
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
                              fontSize: 30,
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

                Spacer(flex: 1),
                Expanded( // 체크 버튼 (홈으로 이동)
                  flex: 6,
                  child: Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.go('/chat'); // 체크 버튼 클릭 시 ChatScreen으로 이동
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemYellow, // 주황색 바탕
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.check_mark, // 체크 아이콘
                          color: CupertinoColors.white, // 체크 색상 하얀색
                          size: 70,
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