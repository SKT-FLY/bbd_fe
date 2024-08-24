import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class TaxiSearchPage extends StatelessWidget {
  final Map<String, dynamic>? taxiData;

  const TaxiSearchPage({Key? key, required this.taxiData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    const Color activeOrange = Color(0xFFFFA500);

    // 택시 데이터가 null이거나, 유효한 데이터가 없을 때의 처리
    if (taxiData == null || taxiData!['type_0'] == null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            '택시 검색',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: activeOrange,
          border: null,
        ),
        child: Center(
          child: Text(
            '택시가 없습니다.',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final String fullAddress = taxiData!['fullAddress'] ?? '위치 정보 없음';
    final String? type1 = taxiData!['type_1'];
    final String type0 = taxiData!['type_0'];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '택시 검색',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: activeOrange,
        border: null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 상단 텍스트 (1 flex)
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '위치: $fullAddress',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 버튼 영역 (10 flex)
            Expanded(
              flex: 10,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (type1 != null) ...[
                      CupertinoButton.filled(
                        onPressed: () {
                          context.push('/calling-screen', extra: type1); // type1 전화번호로 이동
                        },
                        child: Text(
                          '택시 1: $type1',
                          style: const TextStyle(fontSize: 24),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.2,
                        ),
                      ),
                      const SizedBox(height: 16), // 버튼 간 간격
                    ],
                    CupertinoButton.filled(
                      onPressed: () {
                        context.push('/calling-screen', extra: type0); // type0 전화번호로 이동
                      },
                      child: Text(
                        type1 != null ? '택시 2: $type0' : '택시 호출: $type0',
                        style: const TextStyle(fontSize: 24),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
