import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ChatService.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var llmResponseText = "Response to query will be shown here...";

  List<ChatMessage> messages = [];

  ChatUser user = ChatUser(id: "1", firstName: "fulo", lastName: "dev");
  ChatUser llm = ChatUser(id: "2", firstName: "llm", lastName: "openai");

  ChatService chatService = ChatService();

  askLLM() async {
    messages.insert(
      0,
      ChatMessage(
        text: inputController.text,
        createdAt: DateTime.now(),
        user: user,
      ),
    );
    setState(() {
      messages;
    });

    llmResponseText = await chatService.askLLM(inputController.text);

    inputController.text = "";

    messages.insert(
      0,
      ChatMessage(
        text: llmResponseText,
        createdAt: DateTime.now(),
        user: llm,
      ),
    );

    setState(() {
      llmResponseText;
    });

  }

  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("HidayahAi", style: TextStyle(color: Colors.amber)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: DashChat(
                currentUser: user,
                onSend: (ChatMessage m) {
                  setState(() {
                    messages.insert(0, m);
                  });
                },
                readOnly: true,
                messages: messages,
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's on your mind?",
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    askLLM();
                  },
                  icon: Icon(Icons.send, color: Colors.black ,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
