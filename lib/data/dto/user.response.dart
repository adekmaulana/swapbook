import '../models/user.model.dart';
import 'base.response.dart';

class UserResponse extends BaseResponse {
  User? user;
  String? token;

  UserResponse({
    super.meta,
    super.data,
    this.token,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      token: json['data'] != null ? json['data']['token'] : null,
      user: json['data'] != null
          ? json['data']['user'] != null
              ? User.fromJson(json['data']['user'])
              : null
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
