// components_body.dart
import 'package:flutter/material.dart';
import 'chatInputField.dart';
import 'message_bubble.dart';

class ComponentsBody extends StatefulWidget {
  @override
  _ComponentsBodyState createState() => _ComponentsBodyState();
}

class _ComponentsBodyState extends State<ComponentsBody> {
  List<Message> messages = [];

  void addMessage(String content, MessageType type) {
    setState(() {
      messages.add(Message(content: content, isMe: true, type: type));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) => MessageBubble(message: messages[index]),
          ),
        ),
        ChatInputField(onSendMessage: addMessage),
      ],
    );
  }
}
