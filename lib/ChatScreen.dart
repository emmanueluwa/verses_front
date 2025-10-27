import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var llmResponseText = "Response to query will be shown here...";

  String get openaiAPIKey => dotenv.env['OPENAI_API_KEY'] ?? "";

  askLLM() async {
    final response = await post(Uri.parse("https://api.openai.com/v1/chat/completions"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openaiAPIKey'
    },

    body: jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "developer",
          "content": "You are a helpful assistant."
        },
        {
          "role": "user",
          "content": inputController.text
        }
      ]
    }));
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      llmResponseText = jsonData["choices"][0]["message"]["content"];

      setState(() {
        llmResponseText;
      });
    } else {
      print("error occurred");
    }
  }

  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,),
      body: Column(
        children: [
          Expanded(child: Center(child: Text(llmResponseText))),
          Row(
            children: [
              Expanded(child: TextField(controller: inputController)),
              IconButton(onPressed: (){
                print("object");
                askLLM();
                print("done");

              },icon:Icon(Icons.send))
            ],
          )
        ],
      )
    );
  }
}
