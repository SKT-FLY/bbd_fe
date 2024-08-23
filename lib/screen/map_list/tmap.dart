import 'package:flutter/cupertino.dart';
import 'package:bbd_project_fe/api_service.dart';
import 'package:go_router/go_router.dart'; // 서비스 임포트

class TmapScreen extends StatefulWidget {
  final int userId;
  final double centerLat;
  final double centerLon;
  final String searchKeyword;

  const TmapScreen({
    super.key,
    required this.searchKeyword,
    required this.centerLat,
    required this.centerLon,
    required this.userId,
  });

  @override
  _TmapScreenState createState() => _TmapScreenState();
}

class _TmapScreenState extends State<TmapScreen> {
  late Future<List<NearbyHospital>> nearbyHospitalsFuture;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    nearbyHospitalsFuture = _fetchAndProcessHospitals(apiService);
  }

  Future<List<NearbyHospital>> _fetchAndProcessHospitals(ApiService apiService) async {
    final data = await apiService.fetchPois(widget.searchKeyword, widget.centerLat, widget.centerLon);
    //final List<dynamic> pois = data['pois'] as List<dynamic>;
    return data.map((json) => NearbyHospital.fromJson(json as Map<String, dynamic>)).toList();
  }

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
          child: FutureBuilder<List<NearbyHospital>>(
            future: nearbyHospitalsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<NearbyHospital> nearbyHospitals = snapshot.data ?? [];

                // 병원이 없으면 문구 출력
                if (nearbyHospitals.isEmpty) {
                  return const Center(child: Text('근처 병원이 없습니다.'));
                }

                return ListView.builder(
                  itemCount: nearbyHospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = nearbyHospitals[index];
                    return GestureDetector(
                      onTap: () {
                        context.go('/calling-screen', extra: hospital.telNo.toString());
                        print('병원 전화번호: ${hospital.telNo}');
                      },
                      child: _buildHospitalCard(
                        title: hospital.name,
                        department: hospital.detailBizName,
                        address: hospital.fullAddressRoad,
                        distance: '${hospital.radius} km',
                      ),
                    );
                  },
                );
              }
            },
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

// 병원 모델 클래스
class NearbyHospital {
  final String name;
  final String telNo;
  final String fullAddressRoad;
  final String detailBizName;
  final String frontLat;
  final String frontLon;
  final String radius;

  NearbyHospital({
    required this.name,
    required this.telNo,
    required this.fullAddressRoad,
    required this.detailBizName,
    required this.frontLat,
    required this.frontLon,
    required this.radius,
  });

  factory NearbyHospital.fromJson(Map<String, dynamic> json) {
    return NearbyHospital(
      name: json['name'],
      telNo: json['telNo'],
      fullAddressRoad: json['fullAddressRoad'],
      detailBizName: json['detailBizName'],
      frontLat: json['frontLat'],
      frontLon: json['frontLon'],
      radius: json['radius'],
    );
  }
}
