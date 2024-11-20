import 'package:fit_25/Screen/Message.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
const String apiKey = "AIzaSyCd89dV0adlXhDKUYosQu5PV86cD96hQIM";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _generativeModel;
  late final ChatSession _chatSession;
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _generativeModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    _chatSession = _generativeModel.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatSession.history.length,
                itemBuilder: (context, index) {
                  final Content content = _chatSession.history.toList()[index];
                  final text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return Message(
                    text: text,
                    isFormUser: content.role == 'user',
                  );
                },
              ),
            ),
            if (_loading) const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDirection(),
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendChatMessage(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFieldDirection(){
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      hintText: 'Enter  a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14)
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all( 
          Radius.circular(14)
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        )
      ), 
    );
  }

  Future<void> _sendChatMessage(String message) async {
  if (message.trim().isEmpty) return;

  setState(() {
    _loading = true;
  });

  for (int attempt = 1; attempt <= 3; attempt++) { // Attempt 3 times
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      final text = response.text;

      if (text != null) {
        // Process the successful response
        setState(() {
          _scrollDown();
        });
        break; // Exit the loop on success
      } else {
        _showError('No response from API.');
        break; 
      }
    } catch (e) {
      if (e is GenerativeAIException && e.message.contains('503')) {
        // If the specific error is encountered, wait and retry.
        if (attempt < 3) {
          await Future.delayed(Duration(seconds: 5)); // Wait 5 seconds before retrying
        } else {
          _showError('Error: Model is overloaded. Please try again later.');
        }
      } else {
        _showError('Error: $e');
      }
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }
}



  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void _showError(String message){
    showDialog<void>(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }
}
  