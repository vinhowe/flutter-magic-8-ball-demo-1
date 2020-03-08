import 'dart:convert';

import 'package:http/http.dart' as http;

class ResponseApi {
  static final String apiUrl = "https://8ball.delegator.com/magic/JSON/_";

  Future<String> fetchAnswer() async {
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      String answer = jsonResponse["magic"]["answer"];

      print(answer);
      return answer;
    } else {
      throw Exception("Failed to load answer");
    }
  }
}