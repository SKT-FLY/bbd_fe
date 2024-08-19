import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsListScreen extends StatefulWidget {
  @override
  _SmsListScreenState createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> {
  static const platform = MethodChannel('sms_retriever');
  List<String> _smsList = [];
  String selectedMessage = '';

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }

    if (status.isGranted) {
      _fetchSms();
    } else {
      setState(() {
        _smsList = ['SMS permission denied'];
      });
    }
  }

  Future<void> _fetchSms() async {
    try {
      final List<dynamic> smsList = await platform.invokeMethod('getAllSms');
      setState(() {
        _smsList = smsList.cast<String>();
      });
    } on PlatformException catch (e) {
      setState(() {
        _smsList = ['Failed to get SMS: ${e.message}'];
      });
    }
  }

  void _handleSmsTap(String message) {
    setState(() {
      selectedMessage = message;
    });
    print('Selected Message: $selectedMessage');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('All SMS Message'),
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
}
