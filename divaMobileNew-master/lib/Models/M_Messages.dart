
class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final String messageType;
  final bool isRead;
  final String sentAt;
  final Attachment? attachment;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.isRead,
    required this.sentAt,
    this.attachment,
  });

  // Factory constructor to create a Message object from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      messageType: json['message_type'],
      isRead: json['is_read'] == 1, // Assuming 1 is true and 0 is false
      sentAt: json['sent_at'],
      attachment: json['attachment'] != null 
          ? Attachment.fromJson(json['attachment']) 
          : null,
    );
  }

  // Method to convert a Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
      'is_read': isRead ? 1 : 0,
      'sent_at': sentAt,
      'attachment': attachment?.toJson(),
    };
  }
}

class Attachment {
  final int id;
  final String url;

  Attachment({
    required this.id,
    required this.url,
  });

  // Factory constructor to create an Attachment object from JSON
  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      url: json['url'],
    );
  }

  // Method to convert an Attachment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
