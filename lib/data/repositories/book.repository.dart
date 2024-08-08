import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide FormData;

import '../../domain/interfaces/book.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/book.response.dart';
import '../dto/bookmark.response.dart';
import '../dto/books.response.dart';
import '../dto/google_book_search.response.dart';

class BookRepository implements IBookRepository {
  final ApiService _apiService = Get.find<ApiService>();

  BookRepository() {
    _apiService.dio.options.baseUrl = AppUrl.baseUrl;
  }

  @override
  Future<GoogleBookSearchResponse> searchGoogleBooks(String query) async {
    _apiService.dio.options.baseUrl = 'https://www.googleapis.com/books/v1';
    try {
      final response = await _apiService.get(
        '/volumes',
        queryParameters: {
          'q': query,
          'key': dotenv.env['GOOGLE_API_KEY'],
        },
      );
      return GoogleBookSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookResponse> postBook(FormData data) async {
    try {
      final response = await _apiService.post(
        AppUrl.post,
        data: data,
      );

      return BookResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BooksResponse> getBooks(Map<String, dynamic>? query) async {
    try {
      final response = await _apiService.get(
        AppUrl.posts,
        queryParameters: query,
      );
      return BooksResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookResponse> getBook(int id) async {
    try {
      final response = await _apiService.get(
        '${AppUrl.post}/$id',
      );
      return BookResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookmarkResponse> bookmarkBook(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.post(
        '${AppUrl.post}/bookmark',
        data: data,
      );
      return BookmarkResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
