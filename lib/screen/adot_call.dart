import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DialerApp());
}

class DialerApp extends StatelessWidget {
  const DialerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: DialerScreen(),
    );
  }
}

class DialerScreen extends StatelessWidget {
  const DialerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // 상단 병원 이름 및 상태 표시
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '보라매 정형외과',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '에이닷 전화 거는중 ...',
                      style: TextStyle(
                        fontSize: 22,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 번호 패드 영역
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
                    return _buildDialButton(digits[index]);
                  },
                ),
              ),
            ),
            // 하단 버튼 영역
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Container()), // 간격을 비율로 조정
                    _buildActionButton(CupertinoIcons.mic_slash, CupertinoColors.systemGrey, 80),
                    Expanded(child: Container()), // 간격을 비율로 조정
                    _buildActionButton(CupertinoIcons.phone_down_fill, CupertinoColors.systemRed, 100),
                    Expanded(child: Container()), // 간격을 비율로 조정
                    _buildActionButton(CupertinoIcons.speaker_2, CupertinoColors.systemGrey, 80),
                    Expanded(child: Container()), // 간격을 비율로 조정
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 번호 패드 버튼 생성
  Widget _buildDialButton(String digit) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 하단 액션 버튼 생성
  Widget _buildActionButton(IconData icon, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: CupertinoColors.white,
        size: size / 2,
      ),
    );
  }
}
