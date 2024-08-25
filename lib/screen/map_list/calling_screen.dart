import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CallingScreen extends StatefulWidget {
  final String phoneNumber;  // 전화번호 파라미터
  final String displayName;  // 병원 또는 택시 이름

  const CallingScreen({super.key, required this.phoneNumber, required this.displayName});

  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    // 화면의 가로, 세로 크기를 가져옴
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기본 사이즈를 1.2배로 증가시킨 값
    final double scaleFactor = 1.2;

    // 크기 조정된 폰트 사이즈 계산
    final double nameFontSize = 40 * scaleFactor;
    final double phoneFontSize = 26 * scaleFactor;
    final double dialButtonFontSize = 36 * scaleFactor;
    final double dialButtonSize = 80 * scaleFactor;

    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      debugShowCheckedModeBanner: false,  // 디버그 태그 제거
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // 병원 이름과 전화번호를 위아래로 붙여서 표시 (4 flex)
                  Expanded(
                    flex: (6 * scaleFactor).round(),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.displayName,
                            style: TextStyle(
                              fontSize: nameFontSize, // 크기 조정된 폰트 사이즈 사용
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4), // 병원 이름과 전화번호 사이의 간격 (원하는 크기로 조정 가능)
                          Text(
                            widget.phoneNumber,
                            style: TextStyle(
                              fontSize: phoneFontSize, // 크기 조정된 폰트 사이즈 사용
                              color: CupertinoColors.inactiveGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 통화 상태 표시 및 번호 패드 (15 flex)
                  Expanded(
                    flex: (15 * scaleFactor).round(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 방지
                        itemBuilder: (context, index) {
                          final digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
                          return _buildDialButton(digits[index], dialButtonSize, dialButtonFontSize);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.05, // 화면 하단에서 약간 위로 띄움
              left: 0, // 좌측 경계
              right: 0, // 우측 경계
              child: Align(
                alignment: Alignment.bottomCenter, // 하단 중앙 정렬
                child: _buildEndCallButton(dialButtonSize * 1.8), // 크기 조정된 버튼 크기 사용
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 번호 패드 버튼 생성
  Widget _buildDialButton(String digit, double buttonSize, double fontSize) {
    return Container(
      width: buttonSize,  // 크기 조정된 버튼 크기 사용
      height: buttonSize, // 크기 조정된 버튼 크기 사용
      decoration: const BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          digit,
          style: TextStyle(
            fontSize: fontSize, // 크기 조정된 폰트 사이즈 사용
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 통화 종료 버튼 생성
  Widget _buildEndCallButton(double buttonSize) {
    return GestureDetector(
      onTap: () {
        // 버튼 클릭 시 실행할 코드
        context.go('/chat');
      },
      child: Container(
        width: buttonSize * 0.6,  // 크기 조정된 버튼 크기 사용
        height: buttonSize * 0.6, // 크기 조정된 버튼 크기 사용
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed, // 빨간색 배경
          shape: BoxShape.circle, // 원형 모양
        ),
        child: Transform.rotate(
          angle: 3 * 3.14159 / 4 ,  // 270도 회전
          child: Image.asset(
            'assets/images/calldown.png', // 회전할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
