// message_bubble.dart
import 'package:flutter/material.dart';

class Message {
  final String content;
  final bool isMe;
  final MessageType type;

  Message({required this.content, required this.isMe, required this.type});
}

enum MessageType { text, audio, image, file }

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: _buildMessageContent(),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content);
      case MessageType.audio:
        return Row(children: [Icon(Icons.mic), SizedBox(width: 8), Text("Audio message")]);
      case MessageType.image:
        return Image.network(message.content, height: 200);
      case MessageType.file:
        return Row(children: [Icon(Icons.attach_file), SizedBox(width: 8), Text(message.content)]);
    }
  }
}