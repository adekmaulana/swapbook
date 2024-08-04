import 'package:dio/dio.dart';

import '../../../data/dto/base.response.dart';
import '../../../data/repositories/user.repository.dart';

class UpdateLocationUserCase {
  final UserRepository _userRepository = UserRepository();

  Future<BaseResponse> call(FormData data) async {
    try {
      return await _userRepository.updateLocation(data);
    } catch (e) {
      rethrow;
    }
  }
}
