import '../models/book.model.dart';
import 'base.response.dart';

class BookResponse extends BaseResponse {
  Book? book;

  BookResponse({
    super.meta,
    super.data,
    this.book,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      book: json['data'] != null ? Book.fromJson(json['data']) : null,
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
