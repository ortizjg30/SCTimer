import 'dart:convert';

import 'package:http/http.dart';
import 'package:sctimer/class/apicalls.dart';

class ScrambleControl {
  static ApiCalls apiCalls = ApiCalls();
  static bool running = false;
  static Future<String> getScramble(String cubeType) async {
    running = true;
    String scramble = "";
    try {
      String jsonString = jsonEncode(<String, String>{'cubeType': cubeType});
      Response response = await apiCalls.doPost(jsonString, "sistemas");
      Map<String, dynamic> jsonresponse = jsonDecode(response.body);
      if (jsonresponse.isNotEmpty) {
        scramble = jsonresponse['scramble'].toString();
      }
    } catch (e) {
      print(e.toString());
    }
    running = false;
    return scramble.split('[')[0];
  }
}
