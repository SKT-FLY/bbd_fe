import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  runApp(SmsDisplayApp());
}

class SmsDisplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SmsDisplayScreen(),
    );
  }
}

class SmsDisplayScreen extends StatefulWidget {
  @override
  _SmsDisplayScreenState createState() => _SmsDisplayScreenState();
}

class _SmsDisplayScreenState extends State<SmsDisplayScreen> {
  List<String> _smsMessages = [];
  final SmsReceiver _smsReceiver = SmsReceiver();

  @override
  void initState() {
    super.initState();

    _smsReceiver.onSmsReceived.listen((SmsMessage msg) {
      setState(() {
        _smsMessages.add(msg.body ?? "문자 내용을 불러올 수 없습니다.");
      });
      _showSmsDialog(msg.body ?? "문자 내용을 불러올 수 없습니다.");
    });
  }

  // 문자 내용을 바로 화면에 띄우는 다이얼로그
  void _showSmsDialog(String smsBody) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 문자 도착'),
        content: Text(smsBody),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Display'),
      ),
      body: ListView.builder(
        itemCount: _smsMessages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_smsMessages[index]),
          );
        },
      ),
    );
  }
}
