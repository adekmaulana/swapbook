import 'package:dio/dio.dart';

import '../../../data/dto/user.response.dart';
import '../../../data/repositories/user.repository.dart';

class UpdateUserCase {
  final UserRepository _userRepository = UserRepository();

  Future<UserResponse> call(FormData data) async {
    try {
      return await _userRepository.updateUser(data);
    } catch (e) {
      rethrow;
    }
  }
}
