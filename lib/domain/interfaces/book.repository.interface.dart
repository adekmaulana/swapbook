import '../../data/dto/base.response.dart';

abstract class IBookRepository {
  Future<BaseResponse> searchGoogleBooks();
}
