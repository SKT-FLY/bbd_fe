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

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
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
    context.go('/daily-schedule', extra: {
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
        child: Column(
          children: [
            // 상단 월 선택자 (높이 비율: 1/10)
            Flexible(
              flex: 2,
              child: _buildMonthSelector(),
            ),
            const SizedBox(height: 10),
            // 캘린더 (높이 비율: 8/10)
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
            // 하단 홈 버튼 (높이 비율: 1/10)
            Expanded( //홈화면 버튼
              flex: 3,
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
                      color: CupertinoColors.white,
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
          child: const Icon(CupertinoIcons.left_chevron, size: 30),
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
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        CupertinoButton(
          child: const Icon(CupertinoIcons.right_chevron, size: 30),
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
    return TableCalendar<dynamic>(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
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
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        selectedDecoration: const BoxDecoration(
          color: CupertinoColors.black,
          shape: BoxShape.circle,
        ),
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
                    color: day.weekday == DateTime.sunday
                        ? Colors.red
                        : day.weekday == DateTime.saturday
                        ? Colors.blue
                        : Colors.black,
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