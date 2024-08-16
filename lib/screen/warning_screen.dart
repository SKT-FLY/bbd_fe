import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // "주의" 텍스트가 포함된 박스
            Spacer(flex:1),
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5E4DF),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: CupertinoColors.black, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '주의',
                        style: TextStyle(
                          color: Color(0xFFB35A3D),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '문자를 분석하기 위해서는 문자를 복사하여 '
                            '클립보드에 저장해 놓아야 합니다.',
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 확인 버튼
            Expanded(
              flex: 2,
              child: Center(
                child: CupertinoButton.filled(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, horizontal: screenWidth * 0.3),
                  onPressed: () {
                    // 버튼 클릭 시 실행할 코드
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // 하단 네비게이션바(홈 아이콘 포함)
            Expanded(
              flex: 2,
              child: Center(
                child: CupertinoButton(
                  onPressed: () {
                    // 홈 버튼 클릭 시 실행할 코드
                  },
                  child: Container(
                    width: screenHeight * 0.12, // 버튼 크기
                    height: screenHeight * 0.12, // 버튼 크기
                    decoration: BoxDecoration(
                      color: Color(0xFFEFE6E6),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 4), // 그림자 위치
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.home,
                        size: 40,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
