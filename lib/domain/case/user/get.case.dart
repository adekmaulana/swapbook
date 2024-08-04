import '../../../data/dto/user.response.dart';
import '../../../data/repositories/user.repository.dart';

class GetUserCase {
  final UserRepository _userRepository = UserRepository();

  Future<UserResponse> call(String id) async {
    try {
      return await _userRepository.getMe(id);
    } catch (e) {
      rethrow;
    }
  }
}
