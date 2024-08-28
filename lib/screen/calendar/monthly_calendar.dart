import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lunar/lunar.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bbd_project_fe/setting/api_service.dart';
import 'package:bbd_project_fe/setting/user_provider.dart';
import 'package:provider/provider.dart';

class ScheduleMonthlyScreen extends StatefulWidget {
  const ScheduleMonthlyScreen({super.key});

  @override
  _ScheduleMonthlyScreenState createState() => _ScheduleMonthlyScreenState();
}

class _ScheduleMonthlyScreenState extends State<ScheduleMonthlyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _scheduleDataFuture;
  Map<DateTime, List<dynamic>> _events = {};
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("투데이에서 먼슬리 진입");
    _stopAudioPlayer(); // 스크린으로 들어올 때 오디오 플레이어 정지
  }

  Future<void> _stopAudioPlayer() async {
    try {
      print("audio stop");
      await _audioPlayer.stop();  // 이전 음성을 확실히 정지
    } catch (e) {
      print('Failed to stop audio player: $e');
    }
  }

  void _fetchScheduleData() {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    setState(() {
      _scheduleDataFuture = _apiService.fetchScheduleData(userId);
      _scheduleDataFuture.then((schedules) {
        setState(() {
          _events = _groupEventsByDate(schedules);
        });
      }).catchError((error) {
        print('Error fetching schedules: $error');
      });
    });
  }

  Map<DateTime, List<dynamic>> _groupEventsByDate(List<dynamic> schedules) {
    Map<DateTime, List<dynamic>> events = {};
    for (var schedule in schedules) {
      DateTime date = DateTime.parse(schedule['schedule_start_time']).toLocal();
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (events[dateOnly] == null) {
        events[dateOnly] = [];
      }
      events[dateOnly]!.add(schedule);
    }
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final selectedEvents = _events[selectedDay] ?? [];
    context.push('/daily-schedule', extra: {
      'selectedDate': selectedDay,
      'events': selectedEvents,
      'userId': userId});
  }

  String _getLunarDate(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();
    return '${lunar.getMonth()}.${lunar.getDay()}.';
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    return CupertinoPageScaffold(
      navigationBar: null,
      child: SafeArea(
        child: Stack(  // Stack으로 변경하여 캘린더와 버튼을 겹치지 않게 설정
          children: [
            Column(
              children: [
                // 상단 월 선택자 (높이 비율: 2)
                Flexible(
                  flex: 2,
                  child: _buildMonthSelector(),
                ),
                const SizedBox(height: 10),
                // 캘린더 (높이 비율: 16)
                Flexible(
                  flex: 16,
                  child: FutureBuilder<List<dynamic>>(
                    future: _scheduleDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CupertinoActivityIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return _buildCalendar();
                      } else {
                        return const Center(child: Text('일정이 없습니다.'));
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 15,  // 버튼을 화면 하단에서 15px 위로 배치
              left: 0,
              right: 0,
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
          ],
        ),
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
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
                1,
              );
              if (_focusedDay.month == 0) {
                _focusedDay = DateTime(_focusedDay.year - 1, 12, 1);
              }
              _selectedDay = _focusedDay;
            });
          },
        ),
        Text(
          '${_focusedDay.year}년 ${_focusedDay.month}월',
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
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
                1,
              );
              if (_focusedDay.month == 13) {
                _focusedDay = DateTime(_focusedDay.year + 1, 1, 1);
              }
              _selectedDay = _focusedDay;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    DateTime today = DateTime.now(); // 오늘 날짜를 받아옵니다.

    return TableCalendar<dynamic>(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return false; // 선택된 날짜에 대한 동그라미 비활성화
      },
      onDaySelected: _onDaySelected,
      calendarFormat: CalendarFormat.month,
      eventLoader: (day) {
        final dateOnly = DateTime(day.year, day.month, day.day);
        return _events[dateOnly] ?? [];
      },
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 24, color: Colors.black),
        weekendStyle: TextStyle(fontSize: 24, color: Colors.red),
      ),
      daysOfWeekHeight: 40.0,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black, // 검정색으로 가득 채운 원
        ),
        selectedDecoration: const BoxDecoration(),
        outsideDaysVisible: false,
        cellMargin: const EdgeInsets.all(6.0),
        defaultTextStyle: const TextStyle(fontSize: 24),
      ),
      rowHeight: 100.0,
      calendarBuilders: CalendarBuilders<dynamic>(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.saturday) {
            return const Center(
              child: Text(
                '토',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            );
          } else if (day.weekday == DateTime.sunday) {
            return const Center(
              child: Text(
                '일',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            );
          }
          return null;
        },
        defaultBuilder: (context, day, focusedDay) {
          final dateOnly = DateTime(day.year, day.month, day.day);
          final hasEvents = _events[dateOnly]?.isNotEmpty ?? false;
          final isToday = isSameDay(day, today);

          return Stack(
            alignment: Alignment.center,
            children: [
              if (hasEvents) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(3.0),
                  width: 60,
                  height: 60,
                ),
              ],
              Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 24,
                    color: isToday ? Colors.white : // 오늘 날짜는 하얀색으로 표시
                    (day.weekday == DateTime.sunday
                        ? Colors.red
                        : day.weekday == DateTime.saturday
                        ? Colors.blue
                        : Colors.black),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal, // 오늘 날짜는 볼드체
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                child: Text(
                  _getLunarDate(day),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
        markerBuilder: (context, day, events) {
          return Container();
        },
      ),
      locale: 'ko_KR',
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }
}
