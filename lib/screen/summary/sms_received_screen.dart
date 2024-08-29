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
      final List<dynamic> smsList = await platform.invokeMethod('getLatestMessage');
      setState(() {
        _smsList = smsList.cast<String>().take(10).toList(); // 최신 10개의 메시지만 가져옴
      });
    } on PlatformException catch (e) {
      setState(() {
        _smsList = ['Failed to get SMS: ${e.message}'];
      });
    }
  }

  String extractValidText(String input) {
    if (input.startsWith("MMS with subject:")) {
      input = input.substring(17).trim();
    }

    if (input.startsWith("Message:")) {
      input = input.substring(8).trim();
    }

    final regex = RegExp(r'[가-힣a-zA-Z0-9~₩!@#$%^&*()_+\-={}|:.,?><\s]');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return matches.map((match) => match.group(0)).join('');
  }

  String formatMessage(String message, {int linesToRemove = 2}) {
    List<String> lines = message.split('\n');

    if (lines.length > linesToRemove) {
      lines = lines.sublist(linesToRemove);
    } else {
      lines = [];
    }

    lines = lines.take(4).toList();
    return lines.join('\n').trim();
  }

  String getIndexText(int index) {
    switch (index) {
      case 1:
        return "첫 번째 문자";
      case 2:
        return "두 번째 문자";
      case 3:
        return "세 번째 문자";
      case 4:
        return "네 번째 문자";
      case 5:
        return "다섯 번째 문자";
      case 6:
        return "여섯 번째 문자";
      case 7:
        return "일곱 번째 문자";
      case 8:
        return "여덟 번째 문자";
      case 9:
        return "아홉 번째 문자";
      case 10:
        return "열 번째 문자";
      default:
        return "$index 번째 문자";
    }
  }

  bool _isSuspiciousMessage(String message) {
    final lowerCaseMessage = message.toLowerCase();
    return lowerCaseMessage.contains('스미싱') || lowerCaseMessage.contains('광고');
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
    double screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: CupertinoColors.systemYellow,
          ),
          onPressed: () {
            context.go('/chat'); // 이전 화면으로 이동
          },
        ),
        middle: Text('최근 문자 메시지', style: TextStyle(fontSize: 28)),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _smsList.length,
          itemBuilder: (context, index) {
            return _buildSmsCard(index + 1, _smsList[index], screenHeight);
          },
        ),
      ),
    );
  }

  Widget _buildSmsCard(int index, String message, double screenHeight) {
    final filteredMessage = extractValidText(message);
    final formattedMessage = formatMessage(filteredMessage);
    final indexText = getIndexText(index);
    final isSuspicious = _isSuspiciousMessage(filteredMessage);

    double messageHeight = _calculateTextHeight(formattedMessage, 25, FontWeight.w600, screenHeight);

    return GestureDetector(
      onTap: () => _handleSmsTap(message),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
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
            if (isSuspicious) // 스미싱 문자 또는 광고 문자일 경우에만 핑크색 바 표시
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '주의: 스미싱/광고 문자',
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                ),
              ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                indexText,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 35, fontWeight: FontWeight.bold, color: CupertinoColors.black),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: messageHeight,
              child: Text(
                formattedMessage.isEmpty ? '[내용 없음]' : formattedMessage,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 25, fontWeight: FontWeight.w600),
                maxLines: null,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '받은 메시지',
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 16, color: CupertinoColors.systemGrey),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: CupertinoColors.systemYellow,
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTextHeight(String text, double fontSize, FontWeight fontWeight, double maxHeight) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    return textPainter.size.height > maxHeight ? maxHeight : textPainter.size.height;
  }

  void _handleSmsTap(String message) {
    context.push('/start-message-summary', extra: extractValidText(message));
  }
}
