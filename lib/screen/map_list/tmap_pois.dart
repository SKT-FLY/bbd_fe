import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:bbd_project_fe/setting/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../setting/location_provider.dart';

class TmapScreen extends StatefulWidget {
  final int userId;
  final String searchKeyword;
  static const Color customOrange = Color(0xFFF6B32A); // #F6B32A 색상을 정의

  const TmapScreen({
    super.key,
    required this.searchKeyword,
    required this.userId,
  });

  @override
  _TmapScreenState createState() => _TmapScreenState();
}

class _TmapScreenState extends State<TmapScreen> {
  Future<List<NearbyHospital>> nearbyHospitalsFuture = Future.value([]);
  Future<List<FavoriteHospital>> favoriteHospitalsFuture = Future.value([]);

  double? latitude;
  double? longitude;
  String? error;

  @override
  void initState() {
    super.initState();
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _initializeLocationAndFetchData(locationProvider);
  }

  Future<void> _initializeLocationAndFetchData(LocationProvider locationProvider) async {
    if (locationProvider.isLocationPermissionGranted) {
      await locationProvider.checkAndRequestLocationPermission(); // 권한 확인 및 위치 갱신
      final position = locationProvider.currentPosition;

      if (position != null) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });

        final apiService = ApiService();
        setState(() {
          nearbyHospitalsFuture = _fetchAndProcessHospitals(apiService);
          favoriteHospitalsFuture = _fetchFavoriteHospitals(apiService);
        });
      } else {
        print('Failed to retrieve location');
      }
    } else {
      print('Location permission not granted');
    }
  }

  // 두 지점 사이의 거리를 계산하는 함수 (Haversine 공식 사용)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // 지구의 반지름 (단위: km)
    final dLat = _degreeToRadian(lat2 - lat1);
    final dLon = _degreeToRadian(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(lat1)) * cos(_degreeToRadian(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c; // km 단위 거리 반환
    return distance;
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  Future<List<NearbyHospital>> _fetchAndProcessHospitals(ApiService apiService) async {
    print("Fetching nearby hospitals...");
    final data = await apiService.fetchPois(
      widget.searchKeyword,
      latitude: latitude!,
      longitude: longitude!,
    );

    return data.map((json) {
      final hospital = NearbyHospital.fromJson(json as Map<String, dynamic>);

      // 병원과 사용자 간의 거리를 계산
      final distance = calculateDistance(
        latitude!,
        longitude!,
        double.parse(hospital.frontLat),
        double.parse(hospital.frontLon),
      );

      // distance 값을 병원 정보에 추가
      return NearbyHospital(
        name: hospital.name,
        telNo: hospital.telNo,
        fullAddressRoad: hospital.fullAddressRoad,
        detailBizName: hospital.detailBizName,
        frontLat: hospital.frontLat,
        frontLon: hospital.frontLon,
        radius: distance.toStringAsFixed(2), // 거리(km)를 반올림하여 문자열로 저장
      );
    }).toList();
  }

  Future<List<FavoriteHospital>> _fetchFavoriteHospitals(ApiService apiService) async {
    try {
      final List<dynamic> data = await apiService.fetchfavoriteHospitals(widget.userId);

      // List<dynamic>에서 각 요소를 FavoriteHospital로 변환
      return data.map((json) {
        final hospital = FavoriteHospital.fromJson(json as Map<String, dynamic>);

        // 병원과 사용자 간의 거리를 계산
        final distance = calculateDistance(
          latitude!,
          longitude!,
          hospital.hospitalCenterLat,
          hospital.hospitalCenterLon,
        );

        // FavoriteHospital 객체에 distance 값을 추가
        return FavoriteHospital(
          hospitalId: hospital.hospitalId,
          hospitalName: hospital.hospitalName,
          hospitalPhone: hospital.hospitalPhone,
          hospitalType: hospital.hospitalType,
          hospitalAddress: hospital.hospitalAddress,
          hospitalCenterLat: hospital.hospitalCenterLat,
          hospitalCenterLon: hospital.hospitalCenterLon,
          visitsCount: hospital.visitsCount,
          distance: distance.toStringAsFixed(2), // 거리(km)를 반올림하여 문자열로 저장
        );
      }).toList();
    } catch (e) {
      print('Failed to load favorite hospitals: $e');
      return [];
    }
  }

  // 병원 클릭 시 updateVisitsCount API 호출 후 전화번호 화면으로 이동하는 함수 (FavoriteHospital)
  void _onFavoriteHospitalTap(FavoriteHospital hospital) async {
    final apiService = ApiService();
    try {
      await apiService.updateVisitsCount(
          widget.userId,
          hospital.hospitalId,
          hospital.hospitalName,
          hospital.hospitalPhone,
          hospital.hospitalType,
          hospital.hospitalAddress,
          hospital.hospitalCenterLat, // 병원 위도 값 전달
          hospital.hospitalCenterLon  // 병원 경도 값 전달
      );
      context.push(
        '/calling-screen-pois',
        extra: {
          'phoneNumber': hospital.hospitalPhone,
          'hospitalName': hospital.hospitalName,
        },
      );
    } catch (e) {
      print('Failed to update visit count: $e');
    }
  }

  // 근처 병원 클릭 시 updateVisitsCount API 호출 후 전화번호 화면으로 이동하는 함수 (NearbyHospital)
  void _onNearbyHospitalTap(NearbyHospital hospital) async {
    final apiService = ApiService();
    try {
      await apiService.updateVisitsCount(
        widget.userId,
        0, // hospitalId가 없는 경우 임시로 0을 사용 (필요시 수정)
        hospital.name,
        hospital.telNo,
        hospital.detailBizName,
        hospital.fullAddressRoad,
        double.parse(hospital.frontLat), // 병원 위도 값 전달
        double.parse(hospital.frontLon), // 병원 경도 값 전달
      );
      context.push('/calling-screen-pois', extra: {
        'phoneNumber': hospital.telNo,
        'hospitalName': hospital.name,
      });
    } catch (e) {
      print('Failed to update visit count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner:false,
      theme: const CupertinoThemeData(
        primaryColor: TmapScreen.customOrange, // customOrange로 변경
      ),
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16), // 즐겨찾기 제목 위 여백
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,  // 왼쪽 정렬
                  child: Text(
                    '즐겨찾기 목록',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8), // 즐겨찾기 제목 아래 여백

              Expanded(
                flex: 10,
                child: FutureBuilder<List<FavoriteHospital>>(
                  future: favoriteHospitalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final List<FavoriteHospital> favoriteHospitals = snapshot.data ?? [];

                      if (favoriteHospitals.isEmpty) {
                        return const Center(child: Text('즐겨찾는 병원이 없습니다.'));
                      }

                      return ListView.builder(
                        itemCount: favoriteHospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = favoriteHospitals[index];
                          return GestureDetector(
                            onTap: () => _onFavoriteHospitalTap(hospital), // 병원 클릭 시 API 호출 및 화면 전환
                            child: _buildFavoriteHospitalCard(
                              title: hospital.hospitalName,
                              department: hospital.hospitalType,
                              address: hospital.hospitalAddress,
                              distance: '${hospital.distance} km',
                              visitsCount: hospital.visitsCount, // 방문 횟수 전달
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // Cupertino 스타일 Divider
              Container(
                height: 5.0,
                color: CupertinoColors.systemGrey4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              // 거리순 병원 목록
              Expanded(
                flex: 13,
                child: FutureBuilder<List<NearbyHospital>>(
                  future: nearbyHospitalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final List<NearbyHospital> nearbyHospitals = snapshot.data ?? [];

                      if (nearbyHospitals.isEmpty) {
                        return const Center(child: Text('근처 병원이 없습니다.'));
                      }

                      // 병원을 거리순으로 정렬
                      nearbyHospitals.sort((a, b) => double.parse(a.radius).compareTo(double.parse(b.radius)));

                      return ListView.builder(
                        itemCount: nearbyHospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = nearbyHospitals[index];
                          return GestureDetector(
                            onTap: () => _onNearbyHospitalTap(hospital), // 근처 병원 클릭 시 updateVisitsCount 호출 및 화면 전환
                            child: _buildNearbyHospitalCard(
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
            ],
          ),
        ),
      ),
    );
  }

  // 즐겨찾기 병원 카드 생성
  Widget _buildFavoriteHospitalCard({
    required String title,
    required String department,
    required String address,
    required String distance,
    required int visitsCount, // 방문 횟수 추가
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
      width: double.infinity, // 카드의 너비를 설정
      child: Stack(
        children: [
          // 방문 횟수를 표시하는 텍스트 (우상단)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: TmapScreen.customOrange.withOpacity(0.8), // customOrange 사용
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                '방문 횟수: $visitsCount',
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // 병원 정보 표시
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                department,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TmapScreen.customOrange, // customOrange 사용
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
          // 거리를 표시하는 텍스트 (우하단)
          Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              distance,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 근처 병원 카드 생성
  Widget _buildNearbyHospitalCard({
    required String title,
    required String department,
    required String address,
    required String distance,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
      width: double.infinity, // 카드의 너비를 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            department,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TmapScreen.customOrange, // customOrange 사용
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
          // 거리를 표시하는 텍스트 (우하단)
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              distance,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NearbyHospital 클래스 정의
class NearbyHospital {
  final String name;
  final String telNo;
  final String fullAddressRoad;
  final String detailBizName;
  final String frontLat;
  final String frontLon;
  final String radius; // 거리 값으로 사용

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

// FavoriteHospital 클래스 정의
class FavoriteHospital {
  final int hospitalId;
  final String hospitalName;
  final String hospitalPhone;
  final String hospitalType;
  final String hospitalAddress;
  final double hospitalCenterLat;
  final double hospitalCenterLon;
  final int visitsCount;
  final String distance; // 추가된 distance 필드

  FavoriteHospital({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalPhone,
    required this.hospitalType,
    required this.hospitalAddress,
    required this.hospitalCenterLat,
    required this.hospitalCenterLon,
    required this.visitsCount,
    required this.distance,
  });

  factory FavoriteHospital.fromJson(Map<String, dynamic> json) {
    return FavoriteHospital(
      hospitalId: int.tryParse(json['hospital_id'].toString()) ?? 0,
      hospitalName: json['hospital_name'],
      hospitalPhone: json['hospital_phone'],
      hospitalType: json['hospital_type'],
      hospitalAddress: json['hospital_address'],
      hospitalCenterLat: json['hospital_centerLat'].toDouble(),
      hospitalCenterLon: json['hospital_centerLon'].toDouble(),
      visitsCount: json['visits_count'],
      distance: '', // 처음에는 빈 문자열로 초기화하고 나중에 계산하여 할당
    );
  }
}
