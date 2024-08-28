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

  // 유효한 한글, 영어, 숫자, 공백 및 특정 기호를 포함하는 텍스트만 추출하는 함수
  String extractValidText(String input) {
    // "MMS with subject:" 태그가 맨 앞에 있을 경우 제거
    if (input.startsWith("MMS with subject:")) {
      input = input.substring(17).trim(); // "MMS with subject:"를 제거하고 공백 제거
    }

    // "Message:" 태그가 맨 앞에 있을 경우 제거
    if (input.startsWith("Message:")) {
      input = input.substring(8).trim(); // "Message:"를 제거하고 공백 제거
    }

    final regex = RegExp(r'[가-힣a-zA-Z0-9~₩!@#$%^&*()_+\-={}|:.,?><\s]');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return matches.map((match) => match.group(0)).join('');
  }

  // 메시지의 처음 두 줄을 제거하고 나머지를 표시
  String formatMessage(String message, {int linesToRemove = 2}) {
    List<String> lines = message.split('\n');

    // 처음 linesToRemove 줄을 제거합니다.
    if (lines.length > linesToRemove) {
      lines = lines.sublist(linesToRemove);
    } else {
      lines = []; // 만약 삭제할 줄 수가 전체 줄 수를 초과하면 빈 리스트로 설정합니다.
    }

    lines = lines.take(4).toList(); // 최대 4줄만 표시
    return lines.join('\n').trim();
  }

  String getIndexText(int index) {
    // 인덱스를 한글로 변환
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
    final filteredMessage = extractValidText(message); // 유효한 텍스트만 추출
    final formattedMessage = formatMessage(filteredMessage); // 첫 두 줄을 제거하고 최대 4줄까지만 표시
    final indexText = getIndexText(index); // 인덱스 텍스트 생성

    // 텍스트의 높이를 계산하여 동적으로 메시지 박스의 높이를 설정
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
            Container(
              width: double.infinity, // 부모의 너비를 가득 채우도록 설정
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow, // 노란색 배경
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
                maxLines: null, // 줄 수 제한 없음
                overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임표 처리
              ),
            ),
            SizedBox(height: 8), // 간격을 줄임
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
                  size: 28, // 아이콘 크기를 줄임
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
      maxLines: null, // 줄 수 제한 없음
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    // 텍스트 높이가 주어진 최대 높이를 초과하지 않도록 설정
    return textPainter.size.height > maxHeight ? maxHeight : textPainter.size.height;
  }

  void _handleSmsTap(String message) {
    // MessageSummaryScreen으로 이동하면서 파싱된 메시지를 전달
    context.push('/start-message-summary', extra: extractValidText(message));
  }
}