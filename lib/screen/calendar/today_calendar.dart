import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbd_project_fe/setting/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Logger _logger = Logger();
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

    _fetchAndPlaySchedule();  // 추가된 부분
  }

  Future<void> _fetchAndPlaySchedule() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final date = '${_selectedYear}-${_selectedMonth}-${_selectedDay}';

    final result = await _apiService.fetchSchedule(date, userId);

    if (result['status'] == 'success') {
      if (result.containsKey('data')) {
        Uint8List audioBytes = Uint8List.fromList(result['data']);
        await _audioPlayer.play(BytesSource(audioBytes));
        _logger.i('Audio is playing.');
      } else if (result.containsKey('message')) {
        String message = result['message'];
        _logger.i('Received message: $message');
        // 메시지를 화면에 표시하거나 다른 작업 수행
      }
    } else {
      _logger.e('Error: ${result['message'] ?? result['exception']}');
    }
  }

  List<dynamic> _sortSchedules(List<dynamic> schedules) {
    schedules.sort((a, b) {
      String timeA = a['schedule_start_time'] ?? '';
      String timeB = b['schedule_start_time'] ?? '';

      // '하루 종일' 일정인 경우, time 값이 'N/A', 빈 문자열, 또는 'T00:00:00'으로 설정되어 있다고 가정
      if (timeA.isEmpty || timeA == 'N/A' || timeA.endsWith('T00:00:00')) return -1;
      if (timeB.isEmpty || timeB == 'N/A' || timeB.endsWith('T00:00:00')) return 1;

      // 하루 종일 일정이 아니면 시간으로 정렬
      DateTime dateTimeA = DateTime.parse(timeA);
      DateTime dateTimeB = DateTime.parse(timeB);
      return dateTimeA.compareTo(dateTimeB);
    });

    return schedules;
  }

  Future<List<dynamic>> _fetchScheduleData() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      List<dynamic> schedules = await _apiService.fetchScheduleData(userId);

      // 스케줄 데이터를 정렬
      schedules = _sortSchedules(schedules);

      setState(() {
        _schedules = schedules;
      });

      return schedules;
    } catch (e) {
      _logger.e('Error fetching schedules: $e');
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

  String formatTime(String time) {
    // time이 'N/A'거나 빈 문자열이거나 'T00:00:00'으로 끝나는 경우 "하루 종일" 반환
    if (time == 'N/A' || time.isEmpty || time.endsWith('T00:00:00')) {
      return "하루 종일";
    }

    try {
      DateTime dateTime = DateTime.parse(time);
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');

      return "$hour시 $minute분";
    } catch (e) {
      return "하루 종일";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int daysInMonth = _daysInMonth(_selectedYear, _selectedMonth);
    double boxWidth = screenWidth / 6;
    double boxHeight = screenHeight * 0.1;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Flexible(
                  flex: 9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment(0.0, -0.7), // 좌우 가운데 정렬, 위쪽으로 높이 조정
                        child: Text(
                          '$_selectedYear년 $_selectedMonth월',
                          style: TextStyle(
                            fontSize: screenHeight * 0.03, // 원하는 크기로 텍스트 크기 설정
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 30,
                  child: Container(
                    color: CupertinoColors.systemGrey6,
                    child: _buildScheduleList(screenHeight, screenWidth),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.77, // 아래에서 띄운 위치 조정
            left: screenWidth * 0.05, // 좌측 여백 조정
            right: screenWidth * 0.05, // 우측 여백 조정
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.withOpacity(0.7), // 반투명 배경
                borderRadius: BorderRadius.circular(20), // 둥근 테두리
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                height: boxHeight * 0.7, // 슬라이드바 높이 조정
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: daysInMonth,
                  itemBuilder: (context, index) {
                    int day = index + 1;
                    String weekDay = _getWeekDay(_selectedYear, _selectedMonth, day);
                    DateTime currentDay = DateTime(_selectedYear, _selectedMonth, day);
                    bool hasEvent = _hasEventForDay(currentDay);
                    bool isSelected = day == _selectedDay;

                    double widthFactor = isSelected ? 1.1 : 0.8;  // 선택된 날짜 칸의 너비를 1.1배로 키움
                    double heightFactor = isSelected ? 1.8 : 0.8; // 선택된 날짜 칸의 높이를 1.8배로 키움

                    // 선택된 날짜를 중앙에 위치시키기 위해 스크롤 위치 조정
                    if (isSelected) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          (index - 2) * (boxWidth * widthFactor), // 중앙에서 살짝 왼쪽으로 위치 조정
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    }

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                        _scrollController.animateTo(
                          (index - 2) * (boxWidth * widthFactor), // 클릭 시 중앙에 위치하도록 스크롤
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: boxWidth * widthFactor,  // 너비를 조정
                        height: boxHeight * heightFactor, // 높이를 조정
                        margin: EdgeInsets.symmetric(horizontal: 4), // 간격 추가
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : (hasEvent
                              ? Colors.lightGreenAccent
                              : CupertinoColors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day일\n($weekDay)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 텍스트를 굵게 표시
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // 하단 중앙의 달력 버튼 위치 조정
          Positioned(
            bottom: 20, // 버튼의 위치를 아래로 더 내림
            left: screenWidth * 0.4, // 좌측에서 40% 위치
            right: screenWidth * 0.4, // 우측에서 40% 위치
            child: Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final userId = Provider.of<UserProvider>(context, listen: false).userId;
                  context.go('/monthly-calendar', extra: userId);
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
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(double screenHeight, double screenWidth) {
    final filteredSchedules = _schedules.where((schedule) {
      final scheduleDate = DateTime.parse(schedule['schedule_start_time']).toLocal();
      return scheduleDate.year == _selectedYear &&
          scheduleDate.month == _selectedMonth &&
          scheduleDate.day == _selectedDay;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        final schedule = filteredSchedules[index];
        return _buildScheduleCard(
          time: schedule['schedule_start_time'] ?? 'N/A',
          title: schedule['schedule_name'] ?? 'N/A',
          description: schedule['schedule_description'] ?? 'N/A',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        );
      },
    );
  }

  Widget _buildScheduleCard({
    required String time,
    required String title,
    required String description,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      padding: EdgeInsets.all(screenHeight * 0.02),
      margin: EdgeInsets.only(top: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: screenHeight * 0.02,
            offset: Offset(0, screenHeight * 0.004),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatTime(time),
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              color: CupertinoColors.inactiveGray,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            title,
            style: TextStyle(
              fontSize: screenHeight * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            description,
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              color: CupertinoColors.systemGrey,
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
}
