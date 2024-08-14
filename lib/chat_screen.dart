import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('채팅'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 채팅 내용을 보여주는 큰 위젯
            Expanded(
              flex: 4, // 비율: 4
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0), // 화면 가장자리와의 간격 설정
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center, // 내부 콘텐츠를 가운데 정렬
                  child: const Text(
                    '여기에 채팅 내용이 표시됩니다.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  ),
                ),
              ),
            ),
            // 빈 공간
            Spacer(flex: 1), // 비율: 1
            // 하단에 음성 입력 및 네비게이션 버튼 배치
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10, // 비율: 10
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0), // 버튼 사이의 간격 조정
                      child: GestureDetector(
                        onTap: () {
                          // 문자 네비게이션 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0), // 네모 모양
                          ),
                          child: const Center(
                            child: Text(
                              '문자',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12, // 비율: 13
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          // 음성 입력 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          width: 48.0,
                          height: 68.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGreen,
                            shape: BoxShape.circle, // 동그라미 모양
                          ),
                          child: const Icon(
                            CupertinoIcons.mic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10, // 비율: 10
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          // 일정 네비게이션 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0), // 네모 모양
                          ),
                          child: const Center(
                            child: Text(
                              '일정',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
