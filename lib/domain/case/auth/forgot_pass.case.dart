import '../../../data/dto/base.response.dart';
import '../../../data/repositories/auth.repository.dart';

class AuthForgotPassCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<BaseResponse> call(String email) async {
    try {
      final BaseResponse baseResponse = await _authRepository.forgotPassword(
        email,
      );

      return baseResponse;
    } catch (e) {
      rethrow;
    }
  }
}
