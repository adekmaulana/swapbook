import '../../../data/dto/search_user.response.dart';
import '../../../data/repositories/user.repository.dart';

class SearchUserCase {
  final UserRepository _userRepository = UserRepository();

  Future<SearchUserResponse> call(String name) async {
    try {
      return await _userRepository.searchUser(name);
    } catch (e) {
      rethrow;
    }
  }
}
