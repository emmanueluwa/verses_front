import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:verse_front/widgets/verse_message_widget.dart';

import 'ChatService.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var llmResponseText = "Response to query will be shown here...";

  List<ChatMessage> messages = [];

  List<Map<String, dynamic>> verseResponses = [];
  bool isLoading = false;

  ChatUser user = ChatUser(id: "1", firstName: "fulo");
  ChatUser llm = ChatUser(id: "2", firstName: "llm");

  ChatService chatService = ChatService();

  TextEditingController inputController = TextEditingController();

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
      ChatMessage(text: llmResponseText, createdAt: DateTime.now(), user: llm),
    );

    setState(() {
      llmResponseText;
    });
  }

  Future<void> askBackend() async {
    if (inputController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: inputController.text,
      user: user,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, userMessage);
      isLoading = true;
    });

    String userInput = inputController.text;
    inputController.clear();

    final response = await chatService.askBackend(userInput);

    if (response != null && response["recommendations"] != null) {
      verseResponses.insert(0, response);

      final llmMessage = ChatMessage(
        text: "verse_response_${verseResponses.length - 1}",
        createdAt: DateTime.now(),
        user: llm,
      );

      setState(() {
        messages.insert(0, llmMessage);
        isLoading = false;
      });
    } else {
      final errorMessage = ChatMessage(
        text: "Sorry, I could not find any verses, Please try again.",
        createdAt: DateTime.now(),
        user: llm,
      );

      setState(() {
        messages.insert(0, errorMessage);
        isLoading = false;
      });
    }
  }

  void bookmarkVerse(Map<String, dynamic> verseData) {
    // TODO: Implement bookmark functionality
    print(
      "Bookmarked: ${verseData['verse']['surah_name']} ${verseData['verse']['verse_number']}",
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Verse bookmarked!")));
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.black,
    //     title: Text("Hidayah Ai", style: TextStyle(color: Colors.amber)),
    //     centerTitle: true,
    //   ),
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: Center(
    //           child: DashChat(
    //             currentUser: user,
    //             onSend: (ChatMessage m) {
    //               setState(() {
    //                 messages.insert(0, m);
    //               });
    //             },
    //             readOnly: true,
    //             messages: messages,
    //           ),
    //         ),
    //       ),
    //       Card(
    //         color: Colors.white,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(30)),
    //         ),
    //         margin: EdgeInsets.all(10),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 15.0),
    //                 child: TextField(
    //                   controller: inputController,
    //                   decoration: InputDecoration(
    //                     border: InputBorder.none,
    //                     hintText: "What's on your mind?",
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             IconButton(
    //               onPressed: () {
    //                 askLLM();
    //               },
    //               icon: Icon(Icons.send, color: Colors.black ,),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Hidayah AI", style: TextStyle(color: Colors.amber)),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message.user.id == user.id;

                  if (!isUser && message.text.startsWith("verse_response_")) {
                    final responseIndex = int.parse(
                      message.text.split("_").last,
                    );
                    final response = verseResponses[responseIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (response["answer_summary"] != null)
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              response["answer_summary"],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),

                        ...response["recommendations"].map<Widget>((verseData) {
                          return VerseMessageWidget(
                            verseData: verseData,
                            onBookmark: () => bookmarkVerse(verseData),
                          );
                        }).toList(),
                      ],
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.amber[700] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Finding guidance...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
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
                        onSubmitted: (_) => askBackend(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: isLoading ? null : askBackend,
                    icon: Icon(
                      isLoading ? Icons.hourglass_empty : Icons.send,
                      color: isLoading ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
