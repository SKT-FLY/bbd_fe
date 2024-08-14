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
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    '여기에 채팅 내용이 표시됩니다.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // 하단에 음성 입력 및 네비게이션 버튼 배치
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    minSize: 0.0,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      // 문자 네비게이션 버튼 클릭 시 실행할 코드
                    },
                    child: const Text('문자'),
                    color: CupertinoColors.systemBlue,
                  ),
                  CupertinoButton(
                    minSize: 0.0,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      // 음성 입력 버튼 클릭 시 실행할 코드
                    },
                    child: const Icon(CupertinoIcons.mic),
                    color: CupertinoColors.systemGreen,
                  ),
                  CupertinoButton(
                    minSize: 0.0,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      // 일정 네비게이션 버튼 클릭 시 실행할 코드
                    },
                    child: const Text('일정'),
                    color: CupertinoColors.systemBlue,
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