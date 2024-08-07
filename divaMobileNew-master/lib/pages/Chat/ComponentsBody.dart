import 'package:flutter/material.dart';

import 'chatInputField.dart';
import 'message_bubble.dart';

class ComponentsBody extends StatefulWidget {
  final int userId;

  ComponentsBody({required this.userId});

  @override
  _ComponentsBodyState createState() => _ComponentsBodyState();
}

class _ComponentsBodyState extends State<ComponentsBody> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    // Load previous messages for this userId
    loadMessages();
  }

  void loadMessages() {
    // Here you would typically make an API call to load the previous messages
    // For demonstration, we will add some dummy messages
    setState(() {
      messages = [
        Message(content: "Hi there!", isMe: false, type: MessageType.text),
        Message(content: "Hello! How can I help you today?", isMe: true, type: MessageType.text),
      ];
    });
  }

  void addMessage(String content, MessageType type) {
    setState(() {
      messages.add(Message(content: content, isMe: true, type: type));
      // Optionally, send the message to the server here
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
