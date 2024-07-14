import '../models/message.model.dart';
import 'base.response.dart';

class MessagesResponse extends BaseResponse {
  List<Message>? messages;

  MessagesResponse({
    super.meta,
    super.data,
    this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      messages: json['data'] != null && json['data'].isNotEmpty
          ? List<Message>.from(json['data'].map((x) => Message.fromJson(x)))
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
