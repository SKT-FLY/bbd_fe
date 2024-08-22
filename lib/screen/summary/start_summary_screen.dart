import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';  // GoRouter를 import 합니다.
import '../chat_screen.dart';  // ChatScreen을 import 합니다.
import '../loading_screen.dart'; // LoadingScreen을 import 합니다.

class SummaryScreen extends StatefulWidget {
  final String text;
  const SummaryScreen({Key? key, required this.text}) : super(key: key);

  @override
  _MessageSummaryState createState() => _MessageSummaryState();
}

class _MessageSummaryState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            '요약',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.person_crop_circle,
              color: CupertinoColors.black,
            ),
          ),
          backgroundColor: const Color(0xFFFFC436),
          border: null,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                // 상단 이미지와의 간격을 주기 위해 Spacer 사용
                Spacer(flex: 1),

                Expanded(
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
                Expanded(
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
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 텍스트 박스와 요약하기 버튼 사이에 간격을 주기 위해 Spacer 사용
                Spacer(flex: 1),

                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/loading');
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
                          color: CupertinoColors.activeOrange,
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
                          size: 40,
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
