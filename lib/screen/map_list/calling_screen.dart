import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallingScreen extends StatefulWidget {
  final String phoneNumber;  // 전화번호 파라미터 추가

  const CallingScreen({super.key, required this.phoneNumber});

  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Column(
            children: [
              // 상단 병원 이름 및 상태 표시 (3 flex)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 병원 이름
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          '보라매 정형외과',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 전화번호
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '전화번호: ${widget.phoneNumber}',  // 전화번호 표시
                          style: const TextStyle(
                            fontSize: 22,
                            color: CupertinoColors.inactiveGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 통화 상태 표시
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '에이닷 전화 거는중 ...',
                          style: TextStyle(
                            fontSize: 22,
                            color: CupertinoColors.inactiveGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 번호 패드 영역 (8 flex)
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      return _buildDialButton(digits[index]);
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
}
