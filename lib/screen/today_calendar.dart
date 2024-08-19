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
                  child: _buildScheduleList(),
                ),
              ],
            ),
          ),
          // 우측 하단에 고정된 캘린더 버튼 (크기 증가)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 100, // 버튼 크기 증가
              height: 100,
              child: FloatingActionButton(
                onPressed: () {
                  // 캘린더 버튼의 동작 추가
                },
                backgroundColor: CupertinoColors.activeOrange,
                child: const Icon(
                  CupertinoIcons.calendar,
                  size: 70, // 아이콘 크기 증가
                  color: CupertinoColors.white,
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
                maxWidth: boxWidth + 8,
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
    );
  }

  Widget _buildScheduleList() {
    final scheduleList = _schedules[_getScheduleKey()];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: scheduleList != null && scheduleList.isNotEmpty
          ? ListView.builder(
        itemCount: scheduleList.length,
        itemBuilder: (context, index) {
          final schedule = scheduleList[index];
          return _buildScheduleCard(
            time: schedule['time']!,
            title: schedule['title']!,
            description: schedule['description']!,
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '일정이 없습니다.',
              style: TextStyle(fontSize: 20, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
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
