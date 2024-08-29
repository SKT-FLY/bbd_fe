import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';  // GoRouter를 import 합니다.
import 'package:bbd_project_fe/setting/api_service.dart';  // ApiService를 import 합니다.

class SummaryScreen extends StatefulWidget {
  final String text;
  const SummaryScreen({Key? key, required this.text}) : super(key: key);

  @override
  _MessageSummaryState createState() => _MessageSummaryState();
}

class _MessageSummaryState extends State<SummaryScreen> {
  final ApiService apiService = ApiService();

  String parseText(String inputText) {
    // 줄바꿈을 기준으로 텍스트를 나눈 후 배열로 변환
    List<String> lines = inputText.split('\n');

    // 첫 두 줄을 제거하고 나머지 텍스트를 다시 결합
    if (lines.length > 2) {
      lines = lines.sublist(2);
    }

    // 나머지 줄을 다시 합쳐서 반환
    return lines.join('\n').replaceAll('\r', '');
  }

  Future<void> _summarizeText() async {
    final parsedText = parseText(widget.text);
    print(parsedText);

    // ApiService의 analyzeAndForwardMessage 함수 호출
    final data = await apiService.analyzeAndForwardMessage(parsedText);
    print(data);
    print("date"+data['date']);
    print("조건검사");
    if (!mounted) return; // 현재 State가 여전히 활성화된 상태인지 확인
    if (data['date'] != "none" && (data['message_type'] != '스미싱 문자' && data['message_type'] != '광고 문자')) {
      print("TO GO CAL" + data['message_type']);
      final updatedData = {
        'schedule_name': data['summary'],
        'schedule_start_time': data['date'],
        'schedule_description': data['source']
      };
      context.go('/summary-result-calendar', extra: updatedData);
    } else {
      print("normal요약가야함");
      print(data);
      context.go('/summary-result-normal', extra: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                Spacer(flex: 2),
                Expanded( // 메세지 그림 에셋 공간
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Image.asset(
                        'assets/images/message.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex:1),
                Expanded( // 메세지 텍스트 공간
                  flex: 20,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center( // 텍스트를 가운데 정렬
                        child: SingleChildScrollView(
                          child: Text(
                            parseText(widget.text), // 첫 두 줄을 제거한 텍스트를 표시
                            style: const TextStyle(
                              fontSize: 25,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.start, // 텍스트가 시작 위치에 정렬되도록 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 텍스트 박스와 요약하기 버튼 사이에 간격을 주기 위해 Spacer 사용
                Spacer(flex: 1),

                Expanded( // 요약 시작 버튼 공간
                  flex: 4,
                  child: GestureDetector(
                    onTap: () async {
                      await _summarizeText();  // 요약 POST API 호출 및 라우팅
                    },
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemYellow,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        '요약하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // 요약하기 버튼과 홈 아이콘 버튼 사이에 간격을 주기 위해 Spacer 사용
                Spacer(flex: 1),

                Expanded( //홈화면 버튼
                  flex: 6,
                  child: Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.go('/chat');
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemYellow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.black.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.home,
                          color: CupertinoColors.black,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),

                // 하단 여백을 위한 Spacer
                Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
