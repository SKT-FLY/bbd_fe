import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // TimeOfDay 사용을 위한 material import
import 'package:go_router/go_router.dart';
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
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 데이터를 초기화할 때, schedule_start_time을 DateTime으로 변환
    final dateString = widget.data['schedule_start_time'];
    if (dateString != null) {
      scheduleDateTime = DateTime.tryParse(dateString);
    }
  }

  Future<void> _registerSchedule() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (scheduleDateTime != null) {
      // API 호출을 통한 일정 등록
      final result = await ApiService().postSchedule(
        userId,
        widget.data['schedule_name'], // 일정 이름을 data['schedule_name']으로 설정
        scheduleDateTime!,
        widget.data['schedule_description'], // 일정 설명을 data['schedule_description']으로 설정
        1, // hospitalId 예시
      );

      if (result.containsKey('error')) {
        // 오류 처리
        print('일정 등록 오류: ${result['error']}');
      } else {
        // 성공 처리
        print('일정 등록 성공');
        await _navigateToSchedule(userId);
      }
    } else {
      print('Invalid schedule date time');
    }
  }

  Future<void> _navigateToSchedule(int userId) async {
    try {
      List<dynamic> selectedEvents;

      if (userId == 3) {
        // userId가 3이면 보호자 데일리 캘린더로 이동
        selectedEvents = await ApiService().fetchGuardianSchedules(userId);
        context.go('/guardian-daily-schedule', extra: {
          'selectedDate': scheduleDateTime,
          'events': selectedEvents,
          'userId': userId
        });
      } else {
        // 그 외의 경우 기본 데일리 캘린더로 이동
        selectedEvents = await ApiService().fetchScheduleData(userId);
        context.go('/daily-schedule', extra: {
          'selectedDate': scheduleDateTime,
          'events': selectedEvents,
          'userId': userId
        });
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      // 오류가 발생했을 때 추가적인 처리 로직을 여기에 작성할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                        'assets/images/message.png', // 이미지 경로 설정
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 20,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white, // 연한 배경색
                        borderRadius: BorderRadius.circular(20.0),
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
                        child: SingleChildScrollView(
                          child: Text(
                            (widget.data['schedule_name'] ?? '요약 정보 없음') +
                                '\n일시 : ' +
                                (widget.data['schedule_start_time'] ?? '날짜 정보 없음'),
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
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: _registerSchedule, // 일정 등록 함수 호출
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemYellow,
                        borderRadius: BorderRadius.circular(20.0),
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
