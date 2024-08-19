import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneConnectionApp extends StatefulWidget {
  const PhoneConnectionApp({super.key});

  @override
  _PhoneConnectionAppState createState() => _PhoneConnectionAppState();
}

class _PhoneConnectionAppState extends State<PhoneConnectionApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            '전화연결',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.person_crop_circle,
              color: CupertinoColors.black,
            ),
          ),
          backgroundColor: const Color(0xFFFFC436),
          border: null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 첫 번째 그룹: 병원 카드 목록
              Expanded(
                flex: 5, // 전체 Flex 중 5 할당
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildHospitalCard(
                        title: '튼튼 정형외과',
                        department: '정형외과',
                        address: '경기도 과천시 별양동',
                        distance: '2.6km',
                      ),
                      const SizedBox(height: 16),
                      _buildHospitalCard(
                        title: '이내과의원',
                        department: '내과',
                        address: '경기도 과천시 부림동',
                        distance: '2.3km',
                      ),
                    ],
                  ),
                ),
              ),
              // 구분선
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              // 두 번째 그룹: 병원 카드 목록
              Expanded(
                flex: 5, // 전체 Flex 중 5 할당
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildHospitalCard(
                        title: '보라매 정형외과',
                        department: '정형외과',
                        address: '서울 관악구 봉천동',
                        distance: '147m',
                      ),
                      const SizedBox(height: 16),
                      _buildHospitalCard(
                        title: '이정형외과의원',
                        department: '정형외과',
                        address: '서울 동작구 보라매동',
                        distance: '211m',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 하단 홈 버튼
              Expanded(
                flex: 2, // 전체 Flex 중 2 할당
                child: Center(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeOrange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.home,
                        color: CupertinoColors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 병원 카드 생성
  Widget _buildHospitalCard({
    required String title,
    required String department,
    required String address,
    required String distance,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            department,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemOrange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: const TextStyle(
              fontSize: 18,
              color: CupertinoColors.inactiveGray,
            ),
          ),
        ],
      ),
    );
  }
}
