import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final double statusFontSize = 26 * scaleFactor;
    final double dialButtonFontSize = 36 * scaleFactor;
    final double dialButtonSize = 80 * scaleFactor;

    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      debugShowCheckedModeBanner: false,  // 디버그 태그 제거
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Column(
            children: [
              // 병원 또는 택시 이름 표시 (4 flex)
              Expanded(
                flex: (4 * scaleFactor).round(),
                child: Center(
                  child: Text(
                    widget.displayName,
                    style: TextStyle(
                      fontSize: nameFontSize, // 크기 조정된 폰트 사이즈 사용
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 전화번호 표시 (2 flex)
              Expanded(
                flex: (2 * scaleFactor).round(),
                child: Center(
                  child: Text(
                    '전화번호: ${widget.phoneNumber}',
                    style: TextStyle(
                      fontSize: phoneFontSize, // 크기 조정된 폰트 사이즈 사용
                      color: CupertinoColors.inactiveGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 통화 상태 표시 (2 flex)
              Expanded(
                flex: (2 * scaleFactor).round(),
                child: Center(
                  child: Text(
                    '에이닷 전화 거는 중 ...',
                    style: TextStyle(
                      fontSize: statusFontSize, // 크기 조정된 폰트 사이즈 사용
                      color: CupertinoColors.inactiveGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 번호 패드 영역 (12 flex)
              Expanded(
                flex: (12 * scaleFactor).round(),
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
}
