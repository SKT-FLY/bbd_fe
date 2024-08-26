import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // TimeOfDay 사용을 위한 material import
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // DateFormat 사용을 위한 intl import
import 'package:bbd_project_fe/setting/api_service.dart'; // API 서비스 import
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';

class SummaryResultToCalendar extends StatefulWidget {
  final Map<String, dynamic> data; // 서버에서 받은 데이터 객체

  const SummaryResultToCalendar({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _SummaryPage2State createState() => _SummaryPage2State();
}

class _SummaryPage2State extends State<SummaryResultToCalendar> {
  DateTime? scheduleDateTime;

  @override
  void initState() {
    super.initState();
    _parseDateTime();
  }

  void _parseDateTime() {
    try {
      // 서버에서 받은 date를 DateTime 객체로 변환 (예: "2024-08-26 00:00")
      final String dateTimeString = widget.data['date'];

      // DateTime.parse 사용 대신, DateFormat을 사용하여 보다 정확한 파싱
      final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
      scheduleDateTime = format.parse(dateTimeString);
    } catch (e) {
      print('Error parsing date: $e');
      scheduleDateTime = null; // 에러 발생 시 null로 설정
    }
  }

  Future<void> _registerSchedule() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (scheduleDateTime != null) {
      // API 호출을 통한 일정 등록
      final result = await ApiService().postSchedule(
        userId,
        widget.data['source'], // 일정 이름을 data['source']로 설정
        scheduleDateTime!,
        widget.data['summary'],
        1, // hospitalId 예시
      );

      if (result.containsKey('error')) {
        // 오류 처리
        print('일정 등록 오류: ${result['error']}');
      } else {
        // 성공 처리
        print('일정 등록 성공');
        // 추가적으로 성공 알림을 보여주거나 다른 화면으로 이동하는 코드 작성 가능
      }
    } else {
      print('Invalid schedule date time');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CupertinoApp(
      debugShowCheckedModeBanner : false,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/message.png', // 이미지 경로 설정
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Expanded( // 텍스트 박스 공간
                  flex: 22,
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
                            widget.data['summary'], // 요약 텍스트만 표시
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

                Expanded( // 일정 등록 버튼 공간
                  flex: 4,
                  child: GestureDetector(
                    onTap: _registerSchedule, // 일정 등록 함수 호출
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB9B0B0),
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
                          '일정등록',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),

                Expanded( // 홈 버튼 공간
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
