import 'base.response.dart';

class PusherAuthResponse extends BaseResponse {
  String? auth;

  PusherAuthResponse({
    super.meta,
    super.data,
    this.auth,
  });

  factory PusherAuthResponse.fromJson(Map<String, dynamic> json) {
    return PusherAuthResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      auth: json['auth'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'data': data,
      'auth': auth,
    };
  }
}
