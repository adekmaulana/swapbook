import '../../data/dto/search_user.response.dart';

abstract class ISearchRepository {
  Future<SearchUserResponse> searchUser(String name);
}
