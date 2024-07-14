import '../models/user.model.dart';
import 'base.response.dart';

class SearchUserResponse extends BaseResponse {
  List<User>? users;

  SearchUserResponse({
    super.meta,
    super.data,
    this.users,
  });

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) {
    return SearchUserResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      users: json['data'] != null && json['data'].isNotEmpty
          ? List<User>.from(json['data'].map((x) => User.fromJson(x)))
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
