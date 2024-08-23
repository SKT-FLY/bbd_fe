import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<String> _loadingMessages = [
    '일정 등록 중입니다...',
    '요약 중입니다...',
    '데이터 분석 중입니다...',
    '업데이트 중입니다...',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String randomMessage = _loadingMessages[Random().nextInt(_loadingMessages.length)];

    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          const Spacer(flex: 2),
          Expanded(
            flex: 18,
            child: Center(
              child: FadeTransition(
                opacity: _animation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.activeBlue.withOpacity(0.3),
                      ),
                    ),
                    const CupertinoActivityIndicator(
                      radius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: Text(
                randomMessage,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: Image.asset(
                'assets/images/yellow_character.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
