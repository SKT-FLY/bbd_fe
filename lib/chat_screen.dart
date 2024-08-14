import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6, // 배경색을 회색으로 설정
      navigationBar: const CupertinoNavigationBar(
        middle: Text('채팅'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 채팅 내용을 보여주는 큰 위젯
            Expanded(
              flex: 8,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white, // 챗 박스의 배경색을 흰색으로 설정
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도 설정
                        spreadRadius: 2, // 그림자의 퍼짐 정도
                        blurRadius: 6, // 그림자의 블러링 정도
                        offset: Offset(2, 4), // 그림자의 위치 (x, y)
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '여기에 채팅 내용이 표시됩니다.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          // 문자 네비게이션 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0),
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
                    flex: 13,
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
                            shape: BoxShape.circle,
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
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          // 일정 네비게이션 버튼 클릭 시 실행할 코드
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(8.0),
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
