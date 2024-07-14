import '../models/chat.model.dart';
import 'base.response.dart';

class ChatResponse extends BaseResponse {
  Chat? chat;

  ChatResponse({
    super.meta,
    super.data,
    this.chat,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      chat: json['data'] != null ? Chat.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'data': data,
    };
  }
}
