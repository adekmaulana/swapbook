import '../../../data/dto/book.response.dart';
import '../../../data/repositories/book.repository.dart';

class GetBookCase {
  final BookRepository _bookRepository = BookRepository();

  Future<BookResponse> call(int id) async {
    try {
      return _bookRepository.getBook(id);
    } catch (e) {
      rethrow;
    }
  }
}
