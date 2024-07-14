import '../models/chat.model.dart';
import 'base.response.dart';

class ChatsResponse extends BaseResponse {
  List<Chat>? chats;

  ChatsResponse({
    super.meta,
    super.data,
    this.chats,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {
    return ChatsResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      chats: json['data'] != null && json['data'].isNotEmpty
          ? List<Chat>.from(json['data'].map((x) => Chat.fromJson(x)))
          : null,
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
