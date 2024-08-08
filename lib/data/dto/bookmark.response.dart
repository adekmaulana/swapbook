import 'base.response.dart';

class BookmarkResponse extends BaseResponse {
  bool? bookmarked;

  BookmarkResponse({
    super.meta,
    super.data,
    this.bookmarked,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      bookmarked: json['data'] ?? false,
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
