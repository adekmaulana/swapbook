import 'package:dio/dio.dart';

import '../../data/dto/book.response.dart';
import '../../data/dto/bookmark.response.dart';
import '../../data/dto/books.response.dart';
import '../../data/dto/google_book_search.response.dart';

abstract class IBookRepository {
  Future<GoogleBookSearchResponse> searchGoogleBooks(String query);
  Future<BookResponse> postBook(FormData data);
  Future<BooksResponse> getBooks(Map<String, dynamic>? query);
  Future<BookResponse> getBook(int id);
  Future<BookmarkResponse> bookmarkBook(int id, Map<String, dynamic> data);
}
