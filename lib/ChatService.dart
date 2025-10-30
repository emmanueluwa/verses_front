import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ChatService {
  String get openaiAPIKey => dotenv.env['OPENAI_API_KEY'] ?? "";

  askLLM(String userInput) async {
    final response = await post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openaiAPIKey',
      },

      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "developer", "content": "You are a helpful assistant."},
          {"role": "user", "content": userInput},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData["choices"][0]["message"]["content"];
    } else {
      return "there is an error";
    }
  }
  askBackend(String userInput) async {
    final response = await post(
      Uri.parse("http://10.0.2.2:8000/api/verses/query"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"query": userInput, "max_results": 0}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      print(jsonData["recommendations"][0]["tafsir"]["content"]);
      return jsonData["recommendations"][0]["tafsir"]["content"];
    } else {
      return "invalid response";
    }
  }
}
