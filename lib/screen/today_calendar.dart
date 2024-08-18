import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleDailyScreen extends StatefulWidget {
  const ScheduleDailyScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleDailyScreen> {
  int _selectedYear = 2024;
  int _selectedMonth = 8;
  int _selectedDay = 13;
  final ScrollController _scrollController = ScrollController();

  final Map<String, List<Map<String, String>>> _schedules = {
    '2024-08-13': [
      {'time': '07:00', 'title': '아침 산책', 'description': '공원에서 산책'},
      {'time': '10:00', 'title': '병원 진료', 'description': '근처 병원에서 진료'},
      {'time': '12:00', 'title': '점심 식사', 'description': '가족과 함께 점심'},
      {'time': '19:00', 'title': '저녁 드라마 시청', 'description': 'TV에서 드라마 보기'},
    ],
    '2024-08-14': [
      {'time': '08:00', 'title': '아침 요가', 'description': '집에서 가벼운 요가'},
      {'time': '09:00', 'title': '병원 방문', 'description': '정기 검진'},
      {'time': '11:00', 'title': '마트 방문', 'description': '마트에서 장보기'},
      {'time': '14:00', 'title': '친구와 차 마시기', 'description': '근처 카페에서 친구와 대화'},
    ],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
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

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _daysInMonth(_selectedYear, _selectedMonth);
    double boxWidth = MediaQuery.of(context).size.width / 5 - 8;
    double boxHeight = 90;
    double selectedBoxHeight = 110;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '일정',
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
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 월 선택 영역
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        child: const Icon(CupertinoIcons.left_chevron),
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
                        },
                      ),
                      Text(
                        '$_selectedYear년 $_selectedMonth월',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      CupertinoButton(
                        child: const Icon(CupertinoIcons.right_chevron),
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
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  // 날짜 선택 영역 - 선택된 월의 일수만큼 생성
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      children: List.generate(daysInMonth, (index) {
                        int day = index + 1;
                        String weekDay = _getWeekDay(_selectedYear, _selectedMonth, day);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = day;
                            });
                            _scrollToSelectedDay();
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: boxWidth,
                              maxWidth: boxWidth + 8, // overflow 문제 해결을 위해 여유 공간 추가
                            ),
                            child: _buildCalendarDate(
                              day.toString(),
                              weekDay,
                              day == _selectedDay,
                              boxWidth,
                              day == _selectedDay ? selectedBoxHeight : boxHeight,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Divider(
                      thickness: 1,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  // 시간 및 일정 표시 영역
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // 일정 카드와 화면 끝의 패딩 설정
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _schedules[_getScheduleKey()]?.map((schedule) {
                        return _buildScheduleCard(
                          time: schedule['time']!,
                          title: schedule['title']!,
                          description: schedule['description']!,
                        );
                      }).toList() ??
                          [const Center(child: Text('일정이 없습니다.', style: TextStyle(fontSize: 20)))],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24, // 버튼 위치를 약간 더 위로 조정
            right: 24, // 버튼 위치를 약간 더 안쪽으로 조정
            child: SizedBox(
              width: 70, // 버튼 크기를 키움
              height: 70,
              child: FloatingActionButton(
                onPressed: () {
                  // 월력으로 돌아가는 로직을 여기에 추가
                },
                backgroundColor: CupertinoColors.activeOrange,
                child: const Icon(
                  CupertinoIcons.calendar,
                  size: 36, // 아이콘 크기도 키움
                ),
              ),
            ),
          ),
        ],
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

  String _getScheduleKey() {
    return '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
  }

  Widget _buildCalendarDate(String day, String weekDay, bool isSelected, double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Container(
            width: width,
            height: 12,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8B4513) : CupertinoColors.systemGrey,
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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekDay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? CupertinoColors.activeOrange : CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? CupertinoColors.activeOrange : CupertinoColors.black,
                    ),
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
      padding: const EdgeInsets.all(16.0),  // 일정 카드 자체의 패딩
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
