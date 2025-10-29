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
}
