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

  @override
  void initState() {
    super.initState();
    _fetchSms();
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('All SMS Messages'),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: _smsList.length,
          itemBuilder: (context, index) {
            return CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              onPressed: () {},
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
