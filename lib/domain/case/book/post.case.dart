import 'package:dio/dio.dart';

import '../../../data/dto/book.response.dart';
import '../../../data/repositories/book.repository.dart';

class PostBookCase {
  final BookRepository _bookRepository = BookRepository();

  Future<BookResponse> call(FormData data) async {
    try {
      return await _bookRepository.postBook(data);
    } catch (e) {
      rethrow;
    }
  }
}
