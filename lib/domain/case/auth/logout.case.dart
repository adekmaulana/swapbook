import 'package:swapbook/infrastructure/services/pusher.service.dart';

import '../../../data/dto/base.response.dart';
import '../../../data/repositories/auth.repository.dart';

class AuthLogoutCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<BaseResponse> call() async {
    try {
      final response = await _authRepository.logout();

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
