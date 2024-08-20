import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // API 호출
  // 의도 추출 API POST
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
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // 필요한 네 가지 변수만 반환
        return { //data로만 받기 data['standardized_command']
          'standardized_command': data['standardized_command'],
          'result': data['result'],
          'message': data['message'],
          'url': data['url'],
        };
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

}
