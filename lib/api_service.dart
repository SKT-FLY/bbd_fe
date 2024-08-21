import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // @POST intend/process-command
  Future<Map<String, dynamic>> processCommandApi(String message) async {
    final String url = 'http://72.23.241.36:8000/api/v1/process-command';
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
  // @default/update-audio/{id}

  // @POST TTS/process-command
  // @POST TTS/process-command

  // @POST schedules/schedule
  // @GET schedules/schedule
  // @GET schedules/schedules/{schedule_id}
  // @PUT schedules/schedules/{schedule_id}
  // @DELETE schedules/schedules/{schedule_id}
  // @GET schedules/guardian/{guardian_id}/schedules
  // @GET schedules/schedules/data/{date}

  //@GET tmap/pois
  //@POST tmap/taxi-search

  //@GET hospitals/hospitals
  //@POST hospitals/update_visits_count

}


