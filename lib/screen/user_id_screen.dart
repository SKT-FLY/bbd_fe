import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({Key? key}) : super(key: key);

  void _selectUser(BuildContext context, int userId) {
    context.go('/chat', extra: userId);  // 선택한 userId를 extra로 전달
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('사용자 선택'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton.filled(
              child: const Text('User 1'),
              onPressed: () => _selectUser(context, 1),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('User 2'),
              onPressed: () => _selectUser(context, 2),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('User 3'),
              onPressed: () => _selectUser(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}
