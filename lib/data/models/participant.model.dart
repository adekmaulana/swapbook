import 'user.model.dart';

class Participant {
  int? id;
  int? chatId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Participant({
    this.id,
    this.chatId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      chatId: json['chat_id'],
      userId: json['user_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
