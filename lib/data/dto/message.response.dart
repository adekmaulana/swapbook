import '../models/message.model.dart';
import 'base.response.dart';

class MessageResponse extends BaseResponse {
  Message? message;

  MessageResponse({
    super.meta,
    super.data,
    this.message,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      message: json['data'] != null ? Message.fromJson(json['data']) : null,
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
