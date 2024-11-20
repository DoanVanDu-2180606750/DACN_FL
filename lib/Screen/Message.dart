import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.text,
    required this.isFormUser,
    });

    final String text;
    final bool isFormUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isFormUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
              ),
            margin: const EdgeInsets.only(bottom: 8),
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFormUser ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onError,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              children: [
                MarkdownBody(data: text),
              ],
            ),
          )
        )
      ],
    );
  }
}