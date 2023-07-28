import 'package:http/http.dart' as http;

class ApiCalls {
  final url = "https://rubiktimer.jgitsystems.net/";
  Future<http.Response> doPost(String jsonString, String uri) {
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonString,
    );
  }
}
