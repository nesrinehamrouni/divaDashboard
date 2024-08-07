

import 'M_Messages.dart';
import 'user.dart';


class Conversation {
  final int id;
  final User user1;
  final User user2;
  final Message? lastMessage;

  Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      user1: User.fromJson(json['user1']),
      user2: User.fromJson(json['user2']),
      lastMessage: json['lastMessage'] != null ? Message.fromJson(json['lastMessage']) : null,
    );
  }
}
