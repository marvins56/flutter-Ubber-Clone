import 'dart:convert';
import 'package:http/http.dart' as http;
class RequestAssistant {
  static Future<dynamic> getRequest(var url) async {
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String jsondata = response.body;
        var decodedata = jsonDecode(jsondata);
        return decodedata;
      } else {
        return "failed";
      }
    } catch (Exp) {
      return "failed";
    }
  }
}
