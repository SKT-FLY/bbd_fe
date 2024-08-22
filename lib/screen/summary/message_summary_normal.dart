import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';  // GoRouter를 import 합니다.
import '../chat_screen.dart';  // ChatScreen을 import 합니다.
import '../loading_screen.dart'; // LoadingScreen을 import 합니다.

class MessageSummaryScreen extends StatefulWidget {
  const MessageSummaryScreen({super.key});

  @override
  _MessageSummaryState createState() => _MessageSummaryState();
}

class _MessageSummaryState extends State<MessageSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                const SizedBox(height: 10), // 문자 박스를 더 위로 올리기 위해 간격 조정
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
                        margin: const EdgeInsets.only(top: 55), // 문자 박스 더 위로 올림
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
                            children: const [
                              Text(
                                '[서울성모병원 진료예약 확인 알림]',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '- 문*숙 님 / 등록번호: 30756112\n'
                                    '- 일자: 2024년09월19일(목요일)\n'
                                    '- 시간: 10시44분\n'
                                    '- 본관 2층 척추센터 정형외과  김영훈  선생님\n'
                                    '문의 및 예약변경 시 1588-1511로 연락주세요.\n\n'
                                    '카카오톡이 아닌 기존처럼 문자로 받길 원하실 경우에는 우측상단의 "알림톡 받지 않기"를 눌러주시기 바랍니다.',
                                style: TextStyle(
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
                    // 요약하기 버튼을 누르면 LoadingScreen으로 이동
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
                      // 홈 버튼을 누르면 ChatScreen으로 이동
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
