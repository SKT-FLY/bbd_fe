import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbd_project_fe/api_service.dart'; // API 서비스 임포트
import 'package:go_router/go_router.dart';

class ScheduleDailyScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleDailyScreen({Key? key, required this.selectedDate}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedDate.year;
    _selectedMonth = widget.selectedDate.month;
    _selectedDay = widget.selectedDate.day;

    _scheduleDataFuture = _fetchScheduleData(); // API 호출로 데이터 가져오기

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  Future<List<dynamic>> _fetchScheduleData() async {
    try {
      final List<dynamic> schedules = await _apiService.fetchScheduleData(1); // user_id만 사용
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

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _daysInMonth(_selectedYear, _selectedMonth);
    double boxWidth = MediaQuery.of(context).size.width / 5 - 8;
    double boxHeight = 100; // 기존보다 높이를 조금 높임
    double selectedBoxHeight = 120; // 선택된 상자의 높이도 조정

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
                  child: FutureBuilder<List<dynamic>>(
                    future: _scheduleDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CupertinoActivityIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return _buildScheduleList(snapshot.data!);
                      } else {
                        return const Center(
                          child: Text(
                            '일정이 없습니다.',
                            style: TextStyle(fontSize: 20, color: CupertinoColors.systemGrey),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.go('/monthly-calendar');
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.yellow, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
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

  Widget _buildScheduleList(List<dynamic> scheduleList) {
    // 선택된 날짜에 해당하는 일정만 필터링
    final filteredSchedules = scheduleList.where((schedule) {
      final scheduleDate = DateTime.parse(schedule['schedule_start_time']).toLocal();
      return scheduleDate.year == _selectedYear &&
          scheduleDate.month == _selectedMonth &&
          scheduleDate.day == _selectedDay;
    }).toList();

    // 필터링된 일정 목록을 화면에 표시
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

  Widget _buildCalendarDate(String day, String weekDay, bool isSelected, double width, double height) {
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
