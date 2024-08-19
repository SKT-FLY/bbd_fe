import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lunar/lunar.dart'; // lunar 패키지 가져오기

class ScheduleMonthlyScreen extends StatefulWidget {
  const ScheduleMonthlyScreen({Key? key}) : super(key: key);

  @override
  _ScheduleMonthlyScreenState createState() => _ScheduleMonthlyScreenState();
}

class _ScheduleMonthlyScreenState extends State<ScheduleMonthlyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  final Set<DateTime> _holidays = {
    // 2023년 공휴일
    DateTime.utc(2023, 1, 1),  // New Year's Day
    DateTime.utc(2023, 1, 21), // Seollal Holiday
    DateTime.utc(2023, 1, 22), // Seollal (Lunar New Year's Day)
    DateTime.utc(2023, 1, 23), // Seollal Holiday
    DateTime.utc(2023, 3, 1),  // Independence Movement Day
    DateTime.utc(2023, 5, 5),  // Children's Day
    DateTime.utc(2023, 5, 27), // Buddha's Birthday
    DateTime.utc(2023, 6, 6),  // Memorial Day
    DateTime.utc(2023, 8, 15), // Liberation Day
    DateTime.utc(2023, 9, 28), // Chuseok Holiday
    DateTime.utc(2023, 9, 29), // Chuseok
    DateTime.utc(2023, 9, 30), // Chuseok Holiday
    DateTime.utc(2023, 10, 3), // National Foundation Day
    DateTime.utc(2023, 10, 9), // Hangul Day
    DateTime.utc(2023, 12, 25), // Christmas Day

    // 2024년 공휴일
    DateTime.utc(2024, 1, 1),  // New Year's Day
    DateTime.utc(2024, 2, 9),  // Seollal (Lunar New Year's Day)
    DateTime.utc(2024, 2, 10), // Seollal Holiday
    DateTime.utc(2024, 2, 11), // Seollal Holiday
    DateTime.utc(2024, 3, 1),  // Independence Movement Day
    DateTime.utc(2024, 5, 5),  // Children's Day
    DateTime.utc(2024, 5, 15), // Buddha's Birthday
    DateTime.utc(2024, 6, 6),  // Memorial Day
    DateTime.utc(2024, 8, 15), // Liberation Day
    DateTime.utc(2024, 9, 16), // Chuseok
    DateTime.utc(2024, 9, 17), // Chuseok Holiday
    DateTime.utc(2024, 9, 18), // Chuseok Holiday
    DateTime.utc(2024, 10, 3), // National Foundation Day
    DateTime.utc(2024, 10, 9), // Hangul Day
    DateTime.utc(2024, 12, 25), // Christmas Day

    // 2025년 공휴일
    DateTime.utc(2025, 1, 1),  // New Year's Day
    DateTime.utc(2025, 1, 28), // Seollal Holiday
    DateTime.utc(2025, 1, 29), // Seollal (Lunar New Year's Day)
    DateTime.utc(2025, 1, 30), // Seollal Holiday
    DateTime.utc(2025, 3, 1),  // Independence Movement Day
    DateTime.utc(2025, 5, 5),  // Children's Day
    DateTime.utc(2025, 5, 15), // Buddha's Birthday
    DateTime.utc(2025, 6, 6),  // Memorial Day
    DateTime.utc(2025, 8, 15), // Liberation Day
    DateTime.utc(2025, 10, 3), // National Foundation Day
    DateTime.utc(2025, 10, 6), // Chuseok Holiday
    DateTime.utc(2025, 10, 7), // Chuseok
    DateTime.utc(2025, 10, 8), // Chuseok Holiday
    DateTime.utc(2025, 10, 9), // Hangul Day
    DateTime.utc(2025, 12, 25), // Christmas Day
  };

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

  String _getLunarDate(DateTime date) {
    // 양력 날짜를 음력 날짜로 변환
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();
    return '${lunar.getMonth()}.${lunar.getDay()}.';
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
        child: Stack(
          children: [
            Column(
              children: [
                _buildMonthSelector(),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildCalendar(),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context); // 홈 화면으로 돌아가기
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.home,
                      color: Colors.white,
                      size: 40,
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
        markersAlignment: Alignment.bottomCenter, // Remove markers by setting alignment to a position that won't display
        markerSizeScale: 0, // Set marker size to zero
      ),
      rowHeight: 90.0,
      calendarBuilders: CalendarBuilders<String>(
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
          final isHoliday = _holidays.contains(day);
          final hasEvents = _getEventsForDay(day).isNotEmpty;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              if (isHoliday) ...[
                Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  ),
                ),
              ] else if (hasEvents) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ] else if (day.weekday == DateTime.saturday) ...[
                Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ] else if (day.weekday == DateTime.sunday) ...[
                Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.red),
                  ),
                ),
              ] else ...[
                Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              // Lunar date positioned at the bottom
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
          // Explicitly return an empty container to prevent the markers from being rendered
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