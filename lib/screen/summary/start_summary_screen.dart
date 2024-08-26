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
    // 모든 줄바꿈 문자('\n' 및 '\r')를 공백으로 대체하여 줄바꿈을 제거합니다.
    return inputText.replaceAll('\n', '').replaceAll('\r', '');
  }

  Future<void> _summarizeText() async {
    final parsedText = parseText(widget.text);
    print(parsedText);

    // ApiService의 analyzeAndForwardMessage 함수 호출
    final data = await apiService.analyzeAndForwardMessage(parsedText);
    print(data);

    // 날짜 값이 'none'이거나 비어 있는지 확인하여 적절한 라우팅 결정
    if (!mounted) return; // 현재 State가 여전히 활성화된 상태인지 확인
    if (data['date'] == null || data['date'].isEmpty || data['date'].toLowerCase() == 'none') {
      print("Date NONE");
      // 날짜가 없으면 요약 결과 화면으로 이동하고 data를 그대로 전달
      context.go('/summary-result-normal', extra: data);
    } else {
      print("TO GO CAL");
      // 날짜가 있으면 캘린더 결과 화면으로 이동하고 필요한 데이터를 전달
      context.go('/summary-result-calendar', extra: data);
    };
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
                        borderRadius: BorderRadius.circular(8),
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
                            widget.text,
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
                        color: const Color(0xFFB9B0B0),
                        borderRadius: BorderRadius.circular(8),
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
                          fontSize: 25,
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
                          color: CupertinoColors.white,
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