import '../../../data/dto/bookmark.response.dart';
import '../../../data/repositories/book.repository.dart';

class BookmarkBookCase {
  final BookRepository _bookRepository = BookRepository();

  Future<BookmarkResponse> call(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      return _bookRepository.bookmarkBook(
        id,
        data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
