import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmsListScreen extends StatefulWidget {
  @override
  _SmsListScreenState createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> {
  static const platform = MethodChannel('sms_retriever');
  List<String> _smsList = [];
  bool _newSmsReceived = false;

  @override
  void initState() {
    super.initState();
    _fetchSms();  // 초기 SMS 로드
    _listenForNewSms();
  }

  Future<void> _fetchSms() async {
    try {
      final List<dynamic> smsList = await platform.invokeMethod('getLatestSms');
      setState(() {
        _smsList = smsList.cast<String>();
      });
    } on PlatformException catch (e) {
      setState(() {
        _smsList = ['Failed to get SMS: ${e.message}'];
      });
    }
  }

  void _listenForNewSms() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "newSmsReceived") {
        _fetchSms();  // 새로운 메시지를 가져와 갱신
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Recent SMS Messages'),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: _smsList.length,
          itemBuilder: (context, index) {
            return CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              onPressed: () => _handleSmsTap(_smsList[index]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _smsList[index],
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontSize: 16),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSmsTap(String message) {
    print('Selected Message: $message');
  }
}
