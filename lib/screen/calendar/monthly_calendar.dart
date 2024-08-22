import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lunar/lunar.dart';
import 'package:go_router/go_router.dart'; // GoRouter 사용을 위한 import
import 'package:bbd_project_fe/db/schedules.dart'; // 공통 일정 및 공휴일 데이터 import

class ScheduleMonthlyScreen extends StatefulWidget {
  const ScheduleMonthlyScreen({Key? key}) : super(key: key);

  @override
  _ScheduleMonthlyScreenState createState() => _ScheduleMonthlyScreenState();
}

class _ScheduleMonthlyScreenState extends State<ScheduleMonthlyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // 선택한 날짜로 today_calendar.dart로 이동하고 해당 날짜를 전달
    context.go('/daily-schedule', extra: selectedDay);
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  String _getLunarDate(DateTime date) {
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
                    context.go('/chat');  // 홈 버튼을 누르면 ChatScreen으로 이동
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
      eventLoader: getEventsForDay, // 공통 일정 데이터 사용
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
          final isHoliday = holidays.contains(day);
          final hasEvents = getEventsForDay(day).isNotEmpty;

          return Stack(
            alignment: Alignment.center,
            children: [
              if (hasEvents) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent.withOpacity(0.3),
                    shape: BoxShape.circle, // 연한 초록색으로 원형 배경을 그립니다.
                  ),
                  margin: const EdgeInsets.all(6.0), // 여백을 주어 원형을 잘 표시
                  width: 50, // 크기는 상황에 따라 조절 가능합니다.
                  height: 50,
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
                        : isHoliday
                        ? Colors.red
                        : Colors.black, // 일요일은 빨간색, 토요일은 파란색, 나머지는 검은색
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
          // 일정 개수에 따른 동그라미 마커 제거
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
