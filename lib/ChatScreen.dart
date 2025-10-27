import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  askLLM(){
    post(Uri.parse("https://api.openai.com/v1/chat/completions"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${String.fromEnvironment('OPENAI_API_KEY')}'
    },

    body: {
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
    });
  }

  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,),
      body: Column(
        children: [
          Expanded(child: Center(child: Text("Response shown here..."))),
          Row(
            children: [
              Expanded(child: TextField(controller: inputController)),
              IconButton(onPressed: (){
                askLLM();

              },icon:Icon(Icons.send))
            ],
          )
        ],
      )
    );
  }
}
