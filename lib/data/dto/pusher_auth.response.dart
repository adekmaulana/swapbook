import 'base.response.dart';

class PusherAuthResponse extends BaseResponse {
  PusherAuthResponse({
    super.meta,
    super.data,
  });

  factory PusherAuthResponse.fromJson(Map<String, dynamic> json) {
    return PusherAuthResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
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
