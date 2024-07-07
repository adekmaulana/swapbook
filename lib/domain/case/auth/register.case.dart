import '../../../data/dto/base.response.dart';
import '../../../data/repositories/auth.repository.dart';

class AuthRegisterCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<BaseResponse> call(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _authRepository.register(
        name,
        email,
        password,
        passwordConfirmation,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
