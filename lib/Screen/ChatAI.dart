  import 'package:dash_chat_2/dash_chat_2.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_gemini/flutter_gemini.dart';

  class ChatScreen extends StatefulWidget {
    const ChatScreen({super.key});

    @override
    State<ChatScreen> createState() => _ChatScreenState();
  }

  class _ChatScreenState extends State<ChatScreen> {
    final Gemini gemini = Gemini.instance;
    List<ChatMessage> messages = [];

    ChatUser currentUser = ChatUser(
      id: "0",
      firstName: "John Doe",
    );

    ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "AI PROULTRA",
    );

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chat with AI'),
        ),
        body: _buildAI(),
      );
    }

    Widget _buildAI() {
      return DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
      );
    }

    void _sendMessage(ChatMessage chatMessage) {
      setState(() {
        messages = [chatMessage, ...messages];
      });

      try {
        MainAxisAlignment: MainAxisAlignment.start;
        String question = chatMessage.text;
        gemini.streamGenerateContent(question).listen((event) {
          ChatMessage? lastMessage = messages.firstOrNull;

          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            String response = event.content?.parts
                    ?.fold("", (previous, current) => "$previous ${current.text}") ??
                "";
            lastMessage.text += response;

            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            String response = event.content?.parts
                    ?.fold("", (previous, current) => "$previous ${current.text}") ??
                "";
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );

            setState(() {
              messages = [message, ...messages];
            });
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }
