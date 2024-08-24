import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _userId = 0;

  int get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
