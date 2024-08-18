import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleMonthlyScreen extends StatefulWidget {
  const ScheduleMonthlyScreen({Key? key}) : super(key: key);

  @override
  _ScheduleMonthlyScreenState createState() => _ScheduleMonthlyScreenState();
}

class _ScheduleMonthlyScreenState extends State<ScheduleMonthlyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _events = {
      DateTime.utc(2024, 8, 20): ['Meeting with Team A', 'Doctor Appointment'],
      DateTime.utc(2024, 8, 25): ['Project Deadline', 'Call with Client'],
      DateTime.utc(2024, 8, 28): ['Team Lunch', 'Yoga Class'],
      DateTime.utc(2024, 8, 29): [
        'Workshop',
        'Birthday Party',
        'Conference',
        'Meetup',
        'Dinner',
        'Extra Event',
        'a'
      ],
    };
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final events = _getEventsForDay(selectedDay);
    if (events.isNotEmpty) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EventDetailsScreen(events: events),
        ),
      );
    }
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          '일정',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFC436),
        border: null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 10),
            Expanded(
              child: _buildCalendar(), // 스크롤 제거하고 확장된 화면에 달력 표시
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
    return TableCalendar<String>(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _onDaySelected,
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(fontSize: 24, color: Colors.black),
        weekendStyle: const TextStyle(fontSize: 24, color: Colors.red),
      ),
      daysOfWeekHeight: 40.0,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: CupertinoColors.systemGrey.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: CupertinoColors.activeOrange,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        cellMargin: const EdgeInsets.all(6.0),
        defaultTextStyle: const TextStyle(fontSize: 24),
      ),
      rowHeight: 90.0, // 각 날짜 셀의 높이를 줄임
      calendarBuilders: CalendarBuilders<String>(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Positioned(
              bottom: 4,
              child: Column(
                children: [
                  ..._buildEventMarkers(events),
                ],
              ),
            );
          }
          return null;
        },
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                '토',
                style: const TextStyle(fontSize: 24, color: Colors.blue),
              ),
            );
          } else if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '일',
                style: const TextStyle(fontSize: 24, color: Colors.red),
              ),
            );
          }
          return null;
        },
        defaultBuilder: (context, day, focusedDay) {
          if (day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
            );
          } else if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
            );
          }
          return null;
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

  List<Widget> _buildEventMarkers(List<String> events) {
    const maxMarkersPerRow = 3;
    List<Widget> rows = [];

    for (int i = 0; i < events.length; i += maxMarkersPerRow) {
      rows.add(
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 2.0,
          children: events
              .skip(i)
              .take(maxMarkersPerRow)
              .map((event) => Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ))
              .toList(),
        ),
      );
    }

    return rows;
  }
}

// 이벤트 상세 화면
class EventDetailsScreen extends StatelessWidget {
  final List<String> events;

  const EventDetailsScreen({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Event Details'),
        backgroundColor: const Color(0xFFFFC436),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(events[index]),
            );
          },
        ),
      ),
    );
  }
}
