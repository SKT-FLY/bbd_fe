import 'package:flutter/cupertino.dart';

class CupertinoCloudSpinner extends StatefulWidget {
  const CupertinoCloudSpinner({super.key});

  @override
  _CupertinoCloudSpinnerState createState() => _CupertinoCloudSpinnerState();
}

class _CupertinoCloudSpinnerState extends State<CupertinoCloudSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation1 = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation2 = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _animation3 = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main cloud shape (Cupertino style)
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: CupertinoColors.activeOrange,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Animated small sphere 1
          AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Positioned(
                bottom: _animation1.value * 50,
                right: _animation1.value * 30,
                child: child!,
              );
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemYellow,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Animated small sphere 2
          AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Positioned(
                top: _animation2.value * 40,
                left: _animation2.value * 30,
                child: child!,
              );
            },
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Animated small sphere 3
          AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              return Positioned(
                top: _animation3.value * 30,
                right: _animation3.value * 50,
                child: child!,
              );
            },
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
