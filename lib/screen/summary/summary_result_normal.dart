import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SummaryResultScreen_normal extends StatefulWidget {
  final Map<String, dynamic> data;

  const SummaryResultScreen_normal({super.key, required this.data});

  @override
  _SummaryPage1State createState() => _SummaryPage1State();
}

class _SummaryPage1State extends State<SummaryResultScreen_normal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final String summaryText = widget.data['summary'] as String? ?? '요약 정보 없음';
    final String messageType = widget.data['message_type'] as String? ?? '';

    // 텍스트 박스의 배경색은 고정된 색상으로 설정
    final Color textBoxColor = CupertinoColors.white;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Spacer(flex: 2),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/summary.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 24,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: textBoxColor,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                if (messageType == "스미싱 문자") ...[
                                  WidgetSpan(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6868),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '스팸 문자\n\n',
                                        style: const TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                TextSpan(
                                  text: summaryText,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.black,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
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
                              color: CupertinoColors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.check_mark,
                          color: CupertinoColors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
