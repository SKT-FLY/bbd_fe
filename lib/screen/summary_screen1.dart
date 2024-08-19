import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryPage1 extends StatefulWidget {
  const SummaryPage1({super.key});

  @override
  _SummaryPage1State createState() => _SummaryPage1State();
}

class _SummaryPage1State extends State<SummaryPage1> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            '문자분석', // 서비스에 따라 상단 네비게이션바의 이름이 달라져야함!
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.person_crop_circle,
              color: CupertinoColors.black,
            ),
          ),
          backgroundColor: const Color(0xFFFFC436),
          border: null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Text(
                        '요약',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          shadows: [
                            Shadow(
                              color: CupertinoColors.systemGrey,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 8, // 전체 레이아웃의 8/10을 차지
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/summary.png', // 이미지 경로 설정
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 60, left: 0),
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
                        child: const Center(
                          child: Text(
                            '요약 내용',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2, // 전체 레이아웃의 2/10을 차지
                  child: Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeOrange, // 주황색 바탕
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
