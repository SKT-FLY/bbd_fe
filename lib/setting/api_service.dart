import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:bbd_project_fe/setting/config.dart';

class ApiService {

  // TTS API - 일정 설명 목소리
  Future<Map<String, dynamic>> fetchSchedule(String date, int userId) async {
    final String url = '$kimhome/api/v1/schedules/tts/$date?user_id=$userId';
    print('요청 URL: $url'); // 로그 추가

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(Duration(seconds: 20));

      print('응답 상태 코드: ${response.statusCode}'); // 로그 추가

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];

        if (contentType != null && contentType.contains('application/json')) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('message')) {
            final String message = jsonResponse['message'];
            return {'status': 'success', 'message': message};
          } else {
            return {'status': 'error', 'message': '예상하지 못한 응답 형식입니다.'};
          }
        } else if (contentType != null && contentType.contains('audio/wav')) {
          final List<int> audioBytes = response.bodyBytes;
          return {'status': 'success', 'data': audioBytes};
        } else {
          return {'status': 'error', 'message': '알 수 없는 Content-Type: $contentType'};
        }
      } else {
        return {'status': 'error', 'message': '서버 오류: 상태 코드 ${response.statusCode}'};
      }
    } catch (e) {
      return {'status': 'error', 'exception': e.toString()};
    }
  }

  // 일정 등록
  Future<Map<String, dynamic>> postSchedule(int userId, String scheduleName, DateTime scheduleStartTime, String scheduleDescription, int hospitalId) async {
    final String url = '$kimhome/api/v1/schedule?user_id=$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'schedule_name': scheduleName,
          'schedule_start_time': scheduleStartTime.toIso8601String(),
          'schedule_description': scheduleDescription,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다.'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  // 유저의 전체 일정 조회
  Future<List<dynamic>> fetchScheduleData(int userId) async {
    final String url = '$kimhome/api/v1/schedule?user_id=$userId';
    print("전체일정조회");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        print(data);
        return data;
      } else {
        return []; // 서버 오류 시 빈 리스트 반환
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  // 특정 일정 조회
  Future<Map<String, dynamic>> fetchScheduleDetails(int scheduleId, int userId) async {
    final String url = '$kimhome/api/v1/schedule/$scheduleId?user_id=$userId';
    print("특정일정조회");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  // 보호자 일정 확인
  Future<Map<String, dynamic>> fetchGuardianSchedules(int guardianId) async {
    final String url = '$kimhome/api/v1/guardian/$guardianId/schedules';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  // 날짜 별 일정 검색
  Future<Map<String, dynamic>> fetchSchedulesByDate(String date, int userId) async {
    final String url = '$kimhome/api/v1/schedules/date/$date?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  // 병원 검색
  Future<List<dynamic>> fetchPois(String searchKeyword, {required double latitude, required double longitude}) async {
    print("~~~~fetchpois~~~~~~");

    print('Latitude: $latitude, Longitude: $longitude');

    final double lat = latitude;
    final double lon = longitude;
    final String url = '$kimhome/api/v1/pois?version=1&searchKeyword=$searchKeyword&centerLat=$lat&centerLon=$lon&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&radius=0&searchType=all&searchtypCd=R&page=1&count=20&multiPoint=N&poiGroupYn=N';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print('API 응답 데이터: $data');
        final List<dynamic> pois = data['pois'] as List<dynamic>;
        return pois;
      } else {
        throw Exception('Failed to load nearby hospitals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load nearby hospitals. Error: $e');
      throw Exception('Failed to load nearby hospitals. Error: $e');
    }
  }

// 티맵 택시 검색
  Future<Map<String, dynamic>> fetchTaxiSearch({
    required int userId,
    required double latitude,
    required double longitude,
  }) async {
    print('Using Latitude: $latitude, Longitude: $longitude');

    final String url = '$kimhome/api/v1/taxi-search/?user_id=$userId&lat=$latitude&lon=$longitude&coordType=WGS84GEO&addressType=A03&coordYn=N&keyInfo=N&newAddressExtend=Y';
    print("~~~~~~taxi 서버님~~~~~~~~");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print("Received data from server: $data");  // 데이터 확인 출력문 추가
        return data;
      } else {
        print("Error: Server returned status code ${response.statusCode}");
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      print('Error retrieving location or API call failed: $e');
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  // 즐겨찾는 병원 목록
  Future<List<dynamic>> fetchfavoriteHospitals(int userId) async {
    final String url = '$kimhome/api/v1/hospitals?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print('응답 데이터: $data');
        return data.isNotEmpty ? data : [];
      } else {
        throw Exception('Failed to load favorite hospitals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('서버로부터 데이터를 받는 도중 오류 발생: $e');
      throw Exception('Failed to load favorite hospitals. Error: $e');
    }
  }

  // 유저 장소 방문 횟수 증가
  Future<Map<String, dynamic>> updateVisitsCount(
      int userId,
      int hospitalId,
      String hospitalName,
      String hospitalPhone,
      String hospitalType,
      String hospitalAddress,
      double hospitalCenterLat,  // 위도 타입 변경
      double hospitalCenterLon   // 경도 타입 변경
      ) async {
    final String url = '$kimhome/api/v1/hospitals/update_visits_count?user_id=$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'hospital_id': hospitalId,
          'hospital_name': hospitalName,
          'hospital_phone': hospitalPhone,
          'hospital_type': hospitalType,
          'hospital_address': hospitalAddress,
          'hospital_centerLat': hospitalCenterLat,  // 위도 값 추가
          'hospital_centerLon': hospitalCenterLon   // 경도 값 추가
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }

  Future<Map<String, dynamic>> processCommandApi(String message, int userId) async {
    final String url = '$kimhome/api/v1/process-command';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'command': message, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        final errorMessage = '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}';
        print(errorMessage);
        return {'error': errorMessage};
      }
    } catch (e) {
      final exceptionMessage = '서버와의 통신 오류가 있습니다. 예외: ${e.toString()}';
      print(exceptionMessage);
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }


  // 메세지 분석
  Future<Map<String, dynamic>> analyzeAndForwardMessage(String message) async {
    final String url = '$kimhome/api/v1/analyze_and_forward';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'message': message}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': '서버와의 통신 오류가 있습니다.', 'exception': e.toString()};
    }
  }
}
