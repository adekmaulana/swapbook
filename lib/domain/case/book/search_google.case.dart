import '../../../data/dto/google_book_search.response.dart';
import '../../../data/repositories/book.repository.dart';

class SearchGoogleCase {
  final BookRepository _bookRepository = BookRepository();

  Future<GoogleBookSearchResponse> call(String query) async {
    try {
      return await _bookRepository.searchGoogleBooks(query);
    } catch (e) {
      rethrow;
    }
  }
}
