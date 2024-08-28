import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:bbd_project_fe/setting/api_service.dart';

import '../../setting/user_provider.dart';

class GuardianScheduleMonthlyScreen extends StatefulWidget {
  const GuardianScheduleMonthlyScreen({super.key});

  @override
  _GuardianScheduleMonthlyScreenState createState() =>
      _GuardianScheduleMonthlyScreenState();
}

class _GuardianScheduleMonthlyScreenState
    extends State<GuardianScheduleMonthlyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Future<List<dynamic>> _scheduleDataFuture;
  Map<DateTime, List<dynamic>> _events = {};
  Map<int, Color> _userColors = {};
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchGuardianSchedules();
  }

  void _fetchGuardianSchedules() {
    final guardianId = Provider.of<UserProvider>(context, listen: false).userId;
    setState(() {
      _scheduleDataFuture = _apiService.fetchGuardianSchedules(guardianId);
      _scheduleDataFuture.then((events) {
        setState(() {
          _events = _groupEventsByDate(events);
          _assignColorsToUsers();
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

  void _assignColorsToUsers() {
    int colorIndex = 0;
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber
    ];

    _events.forEach((date, schedules) {
      for (var schedule in schedules) {
        int userId = schedule['user_id'];
        if (!_userColors.containsKey(userId)) {
          _userColors[userId] = colors[colorIndex % colors.length];
          colorIndex++;
        }
      }
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final guardianId = Provider.of<UserProvider>(context, listen: false).userId;
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final selectedEvents = _events[selectedDay] ?? [];
    context.go('/guardian-daily-schedule', extra: {
      'selectedDate': selectedDay,
      'events': selectedEvents,
      'userId': guardianId
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: null,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 2,
                  child: _buildMonthSelector(),
                ),
                const SizedBox(height: 10),
                Flexible(
                  flex: 18,
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
              bottom: 16,
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
            Positioned(
              bottom: 20,
              right: 20,
              child: SizedBox(
                width: 40,  // 너비를 50으로 설정
                height: 40,  // 높이를 50으로 설정
                child: FloatingActionButton(
                  onPressed: () {
                    // 플로팅 버튼 눌렀을 때의 동작 정의
                    context.go('/createschedule');
                  },
                  backgroundColor: CupertinoColors.systemYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Positioned(
            //   bottom: 20,
            //   right: 20,
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       // 플로팅 버튼 눌렀을 때의 동작 정의
            //       context.go('/createschedule');
            //     },
            //     backgroundColor: CupertinoColors.systemYellow,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: const Icon(
            //       CupertinoIcons.add,
            //       size: 30,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
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
        selectedDecoration: const BoxDecoration(), // 선택된 날짜에 대한 꾸밈 제거
        selectedTextStyle: const TextStyle(), // 선택된 날짜의 텍스트 스타일을 일반 텍스트와 동일하게 설정
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
          return _buildDayCell(day, focusedDay);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, focusedDay);
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

  Widget _buildDayCell(DateTime day, DateTime focusedDay) {
    final dateOnly = DateTime(day.year, day.month, day.day);
    final events = _events[dateOnly] ?? [];

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
        ),
        if (events.isNotEmpty)
          Positioned(
            top: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(events.length, (index) {
                int userId = events[index]['user_id'];
                String scheduleName = events[index]['schedule_name'];

                if (scheduleName.length > 6) {
                  scheduleName = scheduleName.substring(0, 6) + '...';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Container(
                    width: 90,
                    height: 15,
                    decoration: BoxDecoration(
                      color: _userColors[userId]?.withOpacity(0.8) ??
                          Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        scheduleName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
