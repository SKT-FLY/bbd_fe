import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbd_project_fe/setting/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';

import '../../setting/api_service.dart';
import '../../setting/user_provider.dart';

class ScheduleDailyScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? extraData;

  const ScheduleDailyScreen({
    Key? key,
    required this.selectedDate,
    this.extraData,
  }) : super(key: key);

  @override
  _ScheduleDailyScreenState createState() => _ScheduleDailyScreenState();
}

class _ScheduleDailyScreenState extends State<ScheduleDailyScreen> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  final ScrollController _scrollController = ScrollController();
  late Future<List<dynamic>> _scheduleDataFuture;
  final ApiService _apiService = ApiService();
  List<dynamic> _schedules = [];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedDate.year;
    _selectedMonth = widget.selectedDate.month;
    _selectedDay = widget.selectedDate.day;

    _scheduleDataFuture = _fetchScheduleData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ScrollController 자원 해제
    super.dispose();
  }

  Future<List<dynamic>> _fetchScheduleData() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final List<dynamic> schedules = await _apiService.fetchScheduleData(userId);

      // 디버깅을 위한 print 출력
      print("==== 일정정보 ====== ${schedules.toString()}");

      setState(() {
        _schedules = schedules;
      });

      return schedules;
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  void _scrollToSelectedDay() {
    double screenWidth = MediaQuery.of(context).size.width;
    double targetOffset = (_selectedDay - 1) * (screenWidth / 5) - (screenWidth / 2) + (screenWidth / 10);
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _hasEventForDay(DateTime day) {
    return _schedules.any((schedule) {
      final scheduleDate = DateTime.parse(schedule['schedule_start_time']).toLocal();
      return scheduleDate.year == day.year &&
          scheduleDate.month == day.month &&
          scheduleDate.day == day.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _daysInMonth(_selectedYear, _selectedMonth);
    double boxWidth = MediaQuery.of(context).size.width / 5 - 8;
    double boxHeight = 100;
    double selectedBoxHeight = 120;

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 12, // 상단 콘텐츠 영역의 비율
            child: SafeArea(
              child: Column(
                children: [
                  _buildMonthSelector(),
                  const SizedBox(height: 16),
                  _buildDaySelector(daysInMonth, boxWidth, boxHeight, selectedBoxHeight),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Divider(
                      thickness: 1,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _scheduleDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return _buildScheduleList(snapshot.data!);
                        } else {
                          return const Center(
                            child: Text(
                              '일정이 없습니다.',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: CupertinoColors.systemGrey),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(flex: 1), // 간격을 위한 Spacer
          Expanded(
            flex: 3, // 하단 버튼 영역의 비율
            child: Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final userId = Provider.of<UserProvider>(context, listen: false).userId;
                  context.go('/monthly-calendar', extra: userId);
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
                    CupertinoIcons.calendar,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          child: const Icon(
            CupertinoIcons.left_chevron,
            color: CupertinoColors.systemYellow,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              if (_selectedMonth > 1) {
                _selectedMonth--;
              } else {
                _selectedMonth = 12;
                _selectedYear--;
              }
              _selectedDay = 1;
            });
            _scrollToSelectedDay();
            _fetchScheduleData();  // 날짜 변경 시 새로운 데이터를 가져옴
          },
        ),
        Text(
          '$_selectedYear년 $_selectedMonth월',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        CupertinoButton(
          child: const Icon(
            CupertinoIcons.right_chevron,
            color: CupertinoColors.systemYellow,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              if (_selectedMonth < 12) {
                _selectedMonth++;
              } else {
                _selectedMonth = 1;
                _selectedYear++;
              }
              _selectedDay = 1;
            });
            _scrollToSelectedDay();
            _fetchScheduleData();  // 날짜 변경 시 새로운 데이터를 가져옴
          },
        ),
      ],
    );
  }

  Widget _buildDaySelector(int daysInMonth, double boxWidth, double boxHeight, double selectedBoxHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: List.generate(daysInMonth, (index) {
          int day = index + 1;
          String weekDay = _getWeekDay(_selectedYear, _selectedMonth, day);
          DateTime currentDay = DateTime(_selectedYear, _selectedMonth, day);
          bool hasEvent = _hasEventForDay(currentDay);
          bool isSelected = day == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
              _scrollToSelectedDay();
              _fetchScheduleData();  // 새 날짜의 데이터 가져옴
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: boxWidth,
                maxWidth: boxWidth + 8,
              ),
              child: _buildCalendarDate(
                day.toString(),
                weekDay,
                hasEvent,
                isSelected,
                boxWidth,
                isSelected ? selectedBoxHeight : boxHeight,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleList(List<dynamic> scheduleList) {
    final filteredSchedules = scheduleList.where((schedule) {
      final scheduleDate = DateTime.parse(schedule['schedule_start_time']).toLocal();
      return scheduleDate.year == _selectedYear &&
          scheduleDate.month == _selectedMonth &&
          scheduleDate.day == _selectedDay;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: filteredSchedules.length,
        itemBuilder: (context, index) {
          final schedule = filteredSchedules[index];
          return _buildScheduleCard(
            time: schedule['schedule_start_time'] ?? 'N/A',
            title: schedule['schedule_name'] ?? 'N/A',
            description: schedule['schedule_description'] ?? 'N/A',
          );
        },
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  String _getWeekDay(int year, int month, int day) {
    DateTime date = DateTime(year, month, day);
    const weekDays = ['일', '월', '화', '수', '목', '금', '토'];
    return weekDays[date.weekday % 7];
  }

  Widget _buildCalendarDate(String day, String weekDay, bool hasEvent, bool isSelected, double width, double height) {
    // 요일을 나타내는 인덱스 생성 (1: 월요일, ..., 7: 일요일)
    DateTime currentDay = DateTime(_selectedYear, _selectedMonth, int.parse(day));
    int weekDayIndex = currentDay.weekday; // 1(월) ~ 7(일)

    // 기본 색상 설정
    Color topColor = CupertinoColors.systemGrey; // 기본 회색

    // 선택된 날짜인 경우 상단 티켓 색상 노란색으로 설정
    if (isSelected) {
      topColor = CupertinoColors.systemYellow;
    } else if (weekDayIndex == DateTime.saturday) {
      // 토요일은 파란색
      topColor = CupertinoColors.systemBlue;
    } else if (weekDayIndex == DateTime.sunday) {
      // 일요일은 빨간색
      topColor = CupertinoColors.systemRed;
    }

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Container(
            width: width,
            height: 16,
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? CupertinoColors.systemYellow : Colors.transparent,
                  width: isSelected ? 3.0 : 0.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekDay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? CupertinoColors.systemYellow : CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    alignment: Alignment.center, // Stack의 중앙에 날짜 숫자와 동그라미를 겹치게 정렬
                    children: [
                      // 이벤트가 있는 경우 연두색 반투명 동그라미 추가 (날짜 숫자 뒤에 배치)
                      if (hasEvent)
                        Container(
                          width: width / 2, // 동그라미 크기 조정
                          height: width / 2,
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeGreen.withOpacity(0.3), // 연두색 반투명
                            shape: BoxShape.circle,
                          ),
                        ),
                      // 날짜 숫자 텍스트
                      Text(
                        day,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? CupertinoColors.systemYellow : CupertinoColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildScheduleCard({
    required String time,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 24,
              color: CupertinoColors.inactiveGray,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 24,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
