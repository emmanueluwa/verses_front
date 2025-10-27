import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,),
      body: Column(
        children: [
          Expanded(child: Center(child: Text("Response shown here..."))),
          Row(
            children: [
              Expanded(child: TextField()),
              IconButton(onPressed: (){},icon:Icon(Icons.send))
            ],
          )
        ],
      )
    );
  }
}
