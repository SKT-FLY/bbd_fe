import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'loading_screen.dart';

class MessageSummaryScreen extends StatefulWidget {
  final String? message; // message 파라미터를 추가

  const MessageSummaryScreen({super.key, this.message}); // 생성자에 message 추가

  @override
  _MessageSummaryState createState() => _MessageSummaryState();
}

class _MessageSummaryState extends State<MessageSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final message = widget.message; // 전달받은 메시지 사용

    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            '문자분석',
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text(
                        '문자',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          shadows: [
                            Shadow(
                              color: CupertinoColors.systemGrey,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/message.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 55),
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message ?? '메시지가 없습니다.',
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const LoadingScreen(goToSummaryPage1: true),
                      ),
                    );
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
