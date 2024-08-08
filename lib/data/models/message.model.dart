import 'book.model.dart';
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
  Request? request;

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
    this.request,
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
      request:
          json['request'] != null ? Request.fromJson(json['request']) : null,
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
      'request': request?.toJson(),
    };
  }
}

class Request {
  int? id;
  int? requestBy;
  int? bookId;
  int? messageId;
  RequestStatus? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Book? book;

  Request({
    this.id,
    this.requestBy,
    this.bookId,
    this.messageId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.book,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      requestBy: json['request_by'],
      bookId: json['book_id'],
      messageId: json['message_id'],
      status: RequestStatus.values[json['status']],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      book: json['post'] != null ? Book.fromJson(json['post']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_by': requestBy,
      'book_id': bookId,
      'message_id': messageId,
      'status': status?.index,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'post': book?.toJson(),
    };
  }
}

enum RequestStatus {
  pending,
  approved,
  declined,
  finished,
}
