
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SummaryPage2());
}

class SummaryPage2 extends StatelessWidget {
  const SummaryPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CustomScreen(),
    );
  }
}

class CustomScreen extends StatelessWidget {
  const CustomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '요약',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: const Icon(CupertinoIcons.person_crop_circle, color: CupertinoColors.black),
        ),
        backgroundColor: const Color(0xFFFFC436),
        border: null,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0, // 이미지의 위치는 유지
                        top: 50, // 이미지를 아래로 이동시켜 메시지 박스와 겹치게 함
                        child: Image.asset(
                          'assets/images/schedule.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 120.0), // 메시지 박스를 아래로 이동
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                            // border: Border.all(color: Colors.green),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.black.withOpacity(0.25),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [

                              Text(
                                '날짜',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '2024년 9월 19일 화요일',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeOrange,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '시간',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10시 44분',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeOrange,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '내용',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '서울성모병원 정형외과 방문',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10, // 오른쪽 상단에 위치
                        top: 10, // 제목 텍스트를 더 위로 올림
                        child: const Text(
                          '요약',
                          style: TextStyle(
                            fontSize: 36,
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
                  Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9B0B0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '일정등록',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeOrange,
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
                          color: CupertinoColors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
