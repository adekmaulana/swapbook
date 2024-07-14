import 'chat.model.dart';
import 'user.model.dart';

class Message {
  int? id;
  int? chatId;
  int? userId;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Chat? chat;
  String? type;

  Message({
    this.id,
    this.chatId,
    this.userId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.chat,
    this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      chat: json['chat'] != null ? Chat.fromJson(json['chat']) : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'chat': chat?.toJson(),
      'type': type,
    };
  }
}
