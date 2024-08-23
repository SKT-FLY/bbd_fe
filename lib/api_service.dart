import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bbd_project_fe/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:bbd_project_fe/config.dart';

class ApiService {

  /* 1 TTS API*/

  // @POST TTS/ 일반 목소리 - 미사용
  // @POST TTS/{data} 일정 설명 목소리
  // Future<Map<String, dynamic>> fetchSchedule(String date, int userId) async {
  //   final String url = 'http://172.23.241.36:8000/api/v1/schedules/tts/$date?user_id=$userId';
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // 응답 데이터를 디코딩하여 반환
  //       final Map<String, dynamic> data = jsonDecode(
  //           utf8.decode(response.bodyBytes));
  //       return data;
  //     } else {
  //       return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
  //     }
  //   } catch (e) {
  //     return {
  //       'error': '서버와의 통신 오류가 있습니다.',
  //       'exception': e.toString(),
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> fetchSchedule(String date, int userId) async {
    final String url = '$domitoryUrl/api/v1/schedules/tts/$date?user_id=$userId';
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
        // 응답의 Content-Type 확인
        final contentType = response.headers['content-type'];

        if (contentType != null && contentType.contains('application/json')) {
          // JSON 응답 처리
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('message')) {
            final String message = jsonResponse['message'];
            if (message != '메세지가 없습니다') {
              print('받은 메시지: $message');
              return {'status': 'success', 'message': message};
            } else {
              print('서버로부터 메시지가 없습니다.');
              return {'status': 'no_message', 'message': '서버로부터 메시지가 없습니다.'};
            }
          } else {
            print('예상하지 못한 응답 형식입니다.');
            return {'status': 'error', 'message': '예상하지 못한 응답 형식입니다.'};
          }
        } else if (contentType != null && contentType.contains('audio/wav')) {
          // 바이너리 데이터 처리 (예: 오디오 파일)
          final List<int> bytes = response.bodyBytes;
          print(bytes);

          // 필요 시 바이너리 데이터를 반환하거나, 경로 정보를 반환
          return {'status': 'success', 'data': bytes};

        } else {
          print('알 수 없는 Content-Type: $contentType');
          return {'status': 'error', 'message': '알 수 없는 Content-Type: $contentType'};
        }
      } else {
        print('서버 오류: 상태 코드 ${response.statusCode}');
        return {'status': 'error', 'message': '서버 오류: 상태 코드 ${response.statusCode}'};
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      return {'status': 'error', 'exception': e.toString()};
    }
  }
  /* 2 schedules API*/

  // @POST schedules/schedule
  // 일정 등록
  Future<Map<String, dynamic>> postSchedule(int userId,
      String scheduleName,
      DateTime scheduleStartTime,
      String scheduleDescription,
      int hospitalId) async {
    final String url = '$domitoryUrl/api/v1/schedule?user_id=$userId';

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
        // 데이터를 그대로 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다.'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  // @GET schedules/schedule 전체 일정 조회
  // 유저의 전체 일정 조회
  Future<List<dynamic>> fetchScheduleData(int userId) async {
    final String url = '$domitoryUrl/api/v1/schedule?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes)) as List<dynamic>;
        return data;
      } else {
        return []; // 서버 오류 시 빈 리스트 반환
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }


  // @GET schedules/schedules/{schedule_id}
  // 일정 아이디로 특정 일정 조회
  Future<Map<String, dynamic>> fetchScheduleDetails(int scheduleId,
      int userId) async {
    final String url = '$domitoryUrl/api/v1/schedule/$scheduleId?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  // @PUT schedules/schedules/{schedule_id} 일정 수정
  // @DELETE schedules/schedules/{schedule_id} 일정 삭제

  // @GET schedules/guardian/{guardian_id}/schedules
  // 보호자 일정 확인
  Future<Map<String, dynamic>> fetchGuardianSchedules(int guardianId) async {
    final String url = '$domitoryUrl/api/v1/guardian/$guardianId/schedules';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  // @GET schedules/schedules/data/{date}
  // 날짜 별 일정 검색
  Future<Map<String, dynamic>> fetchSchedulesByDate(String date,
      int userId) async {
    final String url = '$domitoryUrl/api/v1/schedules/date/$date?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  /* 3 TMAP API */

  // @GET tmap/pois
  // 티맵 장소 검색 (병원 케이스) API 호출 함수
  Future<List<dynamic>> fetchPois(String searchKeyword, double centerLat,
      double centerLon) async {
    final String url = 'http://192.168.0.228:8000/api/v1/pois?version=1&searchKeyword=$searchKeyword&centerLat=$centerLat&centerLon=$centerLon&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&radius=0&searchType=all&searchtypCd=R&page=1&count=20&multiPoint=N&poiGroupYn=N';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        print(searchKeyword);
        print('API 응답 데이터: $data');
        final List<dynamic> pois = data['pois'] as List<dynamic>;
        print('Pois 리스트: $pois');

        //final List<dynamic> pois = data['pois'] as List<dynamic>;  // 'pois'를 리스트로 캐스팅
        return pois;
      } else {
        throw Exception(
            'Failed to load nearby hospitals. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load nearby hospitals. Error: $e');
    }
  }


  // @POST tmap/taxi-search
  // 티맵 택시 검색
  Future<Map<String, dynamic>> fetchTaxiSearch(int userId, double lat,
      double lon) async {
    final String url = '$domitoryUrl/api/v1/taxi-search/?user_id=$userId&lat=$lat&lon=$lon&coordType=WGS84GEO&addressType=A03&coordYn=N&keyInfo=N&newAddressExtend=Y';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  /* 4 hospitals API */

  // @GET hospitals/hospitals
  // 유저별 즐겨찾기 병원 검색 API 호출 함수
  Future<Map<String, dynamic>> fetchHospitals(int userId) async {
    final String url = '$domitoryUrl/api/v1/hospitals?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        throw Exception(
            'Failed to load favorite hospitals. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load favorite hospitals. Error: $e');
    }
  }

  // @POST hospitals/update_visits_count
  // 유저 장소 방문 횟수 증가
  Future<Map<String, dynamic>> updateVisitsCount(int userId,
      int hospitalId,
      String hospitalName,
      String hospitalPhone,
      String hospitalType,
      String hospitalAddress,
      int hospitalRadius,) async {
    final String url = '$domitoryUrl/api/v1/hospitals/update_visits_count?user_id=$userId';

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
          'hospital_radius': hospitalRadius,
        }),
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {
          'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  /* 5 intend API */

  // @POST intend/process-command
  // 의도 추출
  Future<Map<String, dynamic>> processCommandApi(String message) async {
    final String url = 'http://192.168.0.228:8000/api/v1/process-command';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'command': message}),
      );

      if (response.statusCode == 200) {
        // 데이터를 그대로 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다.'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
  }

  /* 6 message analysis */
  Future<Map<String, dynamic>> analyzeAndForwardMessage(String message) async {
    final String url = '$domitoryUrl/api/v1/analyze_and_forward';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 디코딩하여 반환
        final Map<String, dynamic> data = jsonDecode(
            utf8.decode(response.bodyBytes));
        return data;
      } else {
        return {'error': '서버와의 통신 오류가 있습니다. 상태 코드: ${response.statusCode}'};
      }
    } catch (e) {
      return {
        'error': '서버와의 통신 오류가 있습니다.',
        'exception': e.toString(),
      };
    }
    /* default */
    //@PUT api/vi/update-audio/{id}
  }
}


