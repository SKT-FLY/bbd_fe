import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class TaxiSearchPage extends StatefulWidget {
  final Map<String, dynamic>? taxiData;
  static const Color customOrange = Color(0xFFF6B32A); // #F6B32A 색상을 정의

  const TaxiSearchPage({Key? key, required this.taxiData}) : super(key: key);

  @override
  _TaxiSearchPageState createState() => _TaxiSearchPageState();
}

class _TaxiSearchPageState extends State<TaxiSearchPage> {
  late String fullAddress;

  @override
  void initState() {
    super.initState();
    fullAddress = _formatAddress(widget.taxiData?['fullAddress'] ?? '위치 정보 없음');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 택시 데이터가 null이거나, 유효한 데이터가 없을 때의 처리
    if (widget.taxiData == null || widget.taxiData!['type_0'] == null) {
      return CupertinoPageScaffold(
        child: Center(
          child: Text(
            '택시가 없습니다.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final String? type1 = widget.taxiData!['type_1'];
    final String type0 = widget.taxiData!['type_0'];

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Column(
          children: [
            // Flex 2: 택시 검색 (연한 회색 배경)
            Expanded(
              flex: 2,
              child: Container(
                color: CupertinoColors.systemGrey4, // 연한 회색 배경색 설정
                child: Center(
                  child: Text(
                    '택시 검색',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ),
            ),
            // Flex 3: 현재 위치
            Expanded(
              flex: 7,
              child: Center(
                child: Text(
                  '현재 위치:\n$fullAddress', // 줄바꿈 적용
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.normal,
                    color: CupertinoColors.black,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true, // 텍스트 자동 줄바꿈 활성화
                  overflow: TextOverflow.visible, // 텍스트 오버플로우 시 보여줄 방식 설정
                ),
              ),
            ),
            // Flex 13: 택시 카드
            Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    if (type1 != null)
                      GestureDetector(
                        onTap: () {
                          context.push(
                            '/calling-screen-taxi',
                            extra: {
                              'phoneNumber': type1,
                              'taxiName': '장애인 콜택시',
                            },
                          );
                        },
                        child: _buildTaxiCard(
                          title: '장애인 콜택시호출',
                          phone: type1,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.push(
                          '/calling-screen-taxi',
                          extra: {
                            'phoneNumber': type0,
                            'taxiName': '일반택시 호출',
                          },
                        );
                      },
                      child: _buildTaxiCard(
                        title: '일반택시 호출',
                        phone: type0,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Flex 4: 홈 버튼
            Expanded(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    context.go('/chat'); // 홈 화면으로 이동
                  },
                  child: Icon(
                    CupertinoIcons.home,
                    color: TaxiSearchPage.customOrange,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 주소를 적절한 위치에서 줄바꿈 처리하는 함수
  String _formatAddress(String address) {
    final int maxLineLength = 20; // 한 줄에 표시할 최대 글자 수
    List<String> lines = [];
    for (int i = 0; i < address.length; i += maxLineLength) {
      int endIndex = i + maxLineLength;
      if (endIndex > address.length) {
        endIndex = address.length;
      }
      lines.add(address.substring(i, endIndex));
    }
    return lines.join('\n'); // 줄바꿈으로 연결된 주소 반환
  }

  Widget _buildTaxiCard({
    required String title,
    required String phone,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      padding: const EdgeInsets.all(24.0),  // 상자의 크기 확장을 위한 padding 조정
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      width: double.infinity, // 카드의 너비를 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,  // "택시 호출" 문구를 20으로 설정
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            phone,
            style: TextStyle(
              fontSize: 40,  // 전화번호를 22로 설정
              color: TaxiSearchPage.customOrange, // 커스텀 색상 사용
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
