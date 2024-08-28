import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../setting/api_service.dart';

class ScheduleRegistrationPage extends StatefulWidget {
  @override
  _ScheduleRegistrationPageState createState() =>
      _ScheduleRegistrationPageState();
}

class _ScheduleRegistrationPageState extends State<ScheduleRegistrationPage> {
  final _userIdController = TextEditingController();
  final _scheduleNameController = TextEditingController();
  final _scheduleDescriptionController = TextEditingController();
  final ApiService _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _registerSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    int userId = int.tryParse(_userIdController.text) ?? 0;
    String scheduleName = _scheduleNameController.text;
    String scheduleDescription = _scheduleDescriptionController.text;

    if (userId == 0 || scheduleName.isEmpty || scheduleDescription.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = '모든 필드를 올바르게 입력해주세요.';
      });
      return;
    }

    Map<String, dynamic> response = await _apiService.postSchedule(
      userId,
      scheduleName,
      _selectedDate,
      scheduleDescription,
      1, // 예시로 hospitalId를 1로 설정했습니다. 실제로는 다른 값이 필요할 수 있습니다.
    );

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      setState(() {
        _errorMessage = response['error'];
      });
    } else {
      // 일정 등록 성공 시 데이터를 전달하면서 다음 화면으로 라우팅
      context.go(
        '/guardian-daily-schedule',
        extra: {
          'selectedDate': _selectedDate,
          'events': [
            {
              'schedule_id': response['schedule_id'] ?? 0,
              'schedule_name': scheduleName,
              'schedule_start_time': _selectedDate.toIso8601String(),
              'schedule_description': scheduleDescription,
              'user_id': userId,
            }
          ]
        },
      );
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _scheduleNameController.dispose();
    _scheduleDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        middle: Text('일정 등록'),
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.systemYellow,
          onPressed: () {
            context.go('/guardian-monthly-schedule');
          },
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            height: screenHeight * 0.7,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoTextField(
                  controller: _userIdController,
                  placeholder: '사용자 ID',
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  keyboardType: TextInputType.number,
                ),
                CupertinoTextField(
                  controller: _scheduleNameController,
                  placeholder: '일정 이름',
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                CupertinoTextField(
                  controller: _scheduleDescriptionController,
                  placeholder: '일정 설명',
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: () async {
                    DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        color: CupertinoColors.systemBackground,
                        child: CupertinoDatePicker(
                          initialDateTime: _selectedDate,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          onDateTimeChanged: (DateTime dateTime) {
                            setState(() {
                              _selectedDate = dateTime;
                            });
                          },
                        ),
                      ),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '날짜 선택',
                    style: TextStyle(color: CupertinoColors.systemYellow),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: CupertinoColors.systemRed),
                  ),
                if (_isLoading)
                  CupertinoActivityIndicator(),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: CupertinoColors.systemYellow,
                    borderRadius: BorderRadius.circular(12.0),
                    onPressed: _registerSchedule,
                    child: Text(
                      '등록',
                      style: TextStyle(color: CupertinoColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
