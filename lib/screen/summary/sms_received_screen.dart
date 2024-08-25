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
      final List<dynamic> smsList = await platform.invokeMethod(
          'getLatestMessage');
      setState(() {
        _smsList = smsList.cast<String>().take(10).toList(); // 최신 10개의 메시지만 가져옴
      });
    } on PlatformException catch (e) {
      setState(() {
        _smsList = ['Failed to get SMS: ${e.message}'];
      });
    }
  }

// 유효한 한글, 영어, 숫자, 공백 및 특정 기호를 포함하는 텍스트만 추출하는 함수
  String extractValidText(String input) {
    final regex = RegExp(r'[가-힣a-zA-Z0-9~₩!@#$%^&*()_+\-={}|:.,?><\s]');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return matches.map((match) => match.group(0)).join('');
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
    final filteredMessage = extractValidText(message); // 유효한 텍스트만 추출
    return GestureDetector(
      onTap: () => _handleSmsTap(message),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8), // 여백을 줄임
        padding: EdgeInsets.all(16), // 패딩을 줄임
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
              filteredMessage.isEmpty ? '[내용 없음]' : filteredMessage,
              style: CupertinoTheme
                  .of(context)
                  .textTheme
                  .textStyle
                  .copyWith(fontSize: 25, fontWeight: FontWeight.w600),
              maxLines: 12, // 최대 12줄까지만 표시
              overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임표 처리
            ),
            SizedBox(height: 8), // 간격을 줄임
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '받은 메시지',
                  style: CupertinoTheme
                      .of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                      fontSize: 16, color: CupertinoColors.systemGrey),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: CupertinoColors.systemYellow,
                  size: 28, // 아이콘 크기를 줄임
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSmsTap(String message) {
    // MessageSummaryScreen으로 이동하면서 파싱된 메시지를 전달
    context.push('/start-message-summary', extra: extractValidText(message));
  }
}