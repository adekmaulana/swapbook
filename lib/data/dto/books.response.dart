import '../models/book.model.dart';
import 'base.response.dart';

class BooksResponse extends BaseResponse {
  List<Book>? books;

  BooksResponse({
    super.meta,
    super.data,
    this.books,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
      books: json['data'] != null && json['data'].isNotEmpty
          ? List<Book>.from(
              json['data'].map((x) => Book.fromJson(x)),
            )
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
