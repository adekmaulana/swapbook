import '../../../data/dto/books.response.dart';
import '../../../data/repositories/book.repository.dart';

class GetBooksCase {
  final BookRepository _bookRepository = BookRepository();

  Future<BooksResponse> call(Map<String, dynamic>? query) async {
    try {
      return _bookRepository.getBooks(query);
    } catch (e) {
      rethrow;
    }
  }
}
