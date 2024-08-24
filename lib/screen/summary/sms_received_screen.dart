import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmsListScreen extends StatefulWidget {
  const SmsListScreen({super.key});

  @override
  _SmsListScreenState createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> with WidgetsBindingObserver {
  static const platform = MethodChannel('sms_retriever');
  List<String> _smsList = [];
  bool _newSmsReceived = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchSms(); // 초기 SMS 로드
    _listenForNewSms();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아올 때 새로운 SMS 수신 여부를 확인
      _listenForNewSms();
    }
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
        _fetchSms(); // 새로운 메시지를 가져와 갱신
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('최근 문자 메시지', style: TextStyle(fontSize: 22)),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _smsList.length,
          itemBuilder: (context, index) {
            return _buildSmsCard(_smsList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildSmsCard(String message) {
    return GestureDetector(
      onTap: () => _handleSmsTap(message),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .copyWith(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '받은 메시지',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 18, color: CupertinoColors.systemGrey),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: CupertinoColors.systemYellow,
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSmsTap(String message) {
    // MessageSummaryScreen으로 이동하면서 message 전달
    context.push('/start-message-summary', extra: message);
  }
}
