import 'message.model.dart';
import 'participant.model.dart';

class Chat {
  int? id;
  int? createdBy;
  bool? isPrivate;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int? unreadCount;
  Message? lastMessage;
  List<Participant>? participants;

  Chat({
    this.id,
    this.createdBy,
    this.isPrivate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.unreadCount,
    this.lastMessage,
    this.participants,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      createdBy: json['created_by'],
      isPrivate: json['is_private'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      deletedAt: DateTime.tryParse(json['deleted_at'] ?? ''),
      unreadCount: json['unread_count'],
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      participants:
          json['participants'] != null && json['participants'].isNotEmpty
              ? List<Participant>.from(
                  json['participants'].map((x) => Participant.fromJson(x)),
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'is_private': isPrivate,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'unread_count': unreadCount,
      'last_message': lastMessage?.toJson(),
      'participants': participants != null
          ? List<dynamic>.from(participants!.map((x) => x.toJson()))
          : null,
    };
  }
}
