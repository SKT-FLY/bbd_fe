import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../setting/user_provider.dart';

class AdotScreen extends StatefulWidget {
  @override
  _AdotScreenState createState() => _AdotScreenState();
}

class _AdotScreenState extends State<AdotScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _selectUser(BuildContext context, int id) {
    Provider.of<UserProvider>(context, listen: false).setUserId(id);
    context.go('/chat');  // 선택한 userId를 설정하고 채팅 화면으로 이동
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..repeat(reverse: true); // 애니메이션을 반복하며 깜빡거림 효과를 줌

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 크기 정보 가져오기
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('에이닷'),
        backgroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _selectUser(context, 1),
          child: CustomPaint(
            size: Size(24, 24), // 아이콘의 크기를 설정
            painter: MenuIconPainter(), // CustomPainter로 아이콘을 그림
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _selectUser(context, 3),
          child: CustomPaint(
            size: Size(24, 24), // 아이콘의 크기를 설정
            painter: DotsIconPainter(), // CustomPainter로 점 세 개 아이콘을 그림
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05), // 화면 크기의 5%를 패딩으로 설정
              child: SingleChildScrollView( // SingleChildScrollView로 감싸서 스크롤 가능하게 설정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '깊은 밤이에요. 오늘 하루를 마무리하는\n편안한 시간 보내세요.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CupertinoButton(
                      onPressed: () {},
                      color: CupertinoColors.systemGrey6,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '잠이 안 올 때는 어떻게 해야 돼?',
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CupertinoButton(
                      onPressed: () {},
                      color: CupertinoColors.systemGrey6,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '빵을 잘 굽는 방법 알려줘',
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CupertinoButton(
                      onPressed: () {},
                      color: CupertinoColors.systemGrey6,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '아보카도의 효능은 뭐야?',
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: CupertinoButton(
                    child: Image.asset(
                      'assets/images/click_button.png',
                      width: screenWidth * 0.2, // 화면 너비의 20%로 아이콘 크기 설정
                      height: screenWidth * 0.2, // 화면 너비의 20%로 아이콘 크기 설정
                    ),
                    onPressed: () {
                      // 버튼 클릭 시 실행할 기능 추가
                    },
                  ),
                ),
                Spacer(), // 빈 공간을 추가하여 마이크 버튼을 아래로 밀어냄
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02), // 화면 크기의 2%를 패딩으로 설정
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          placeholder: '궁금하거나 필요한 것을 말씀해 주세요',
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015, // 화면 높이의 1.5%를 패딩으로 설정
                            horizontal: screenWidth * 0.025, // 화면 너비의 2.5%를 패딩으로 설정
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.systemGrey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.all(screenWidth * 0.025), // 화면 크기의 2.5%를 패딩으로 설정
                        child: Icon(
                          CupertinoIcons.mic,
                          size: screenWidth * 0.06, // 아이콘 크기를 화면 너비의 6%로 설정
                          color: CupertinoColors.black, // 아이콘 색상을 검정으로 설정
                        ),
                        onPressed: () {
                          // 마이크 버튼 기능 추가
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter를 사용하여 원하는 스타일의 메뉴 아이콘을 그립니다.
class MenuIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // 첫 번째 줄
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.3),
      paint,
    );
    // 두 번째 줄 (중간 줄, 더 짧게, 왼쪽에 맞춤)
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.5),
      paint,
    );
    // 세 번째 줄
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// 세 개의 점을 그리는 CustomPainter
class DotsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.black
      ..strokeWidth = 1.3 // 점의 굵기를 설정
      ..strokeCap = StrokeCap.round;

    // 첫 번째 점
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.25),
      1.7, // 점의 반지름을 설정
      paint,
    );

    // 두 번째 점
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.5),
      1.7,
      paint,
    );

    // 세 번째 점
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.75),
      1.7,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
