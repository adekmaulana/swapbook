import '../../../data/repositories/auth.repository.dart';

class AuthPingCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> call() async {
    try {
      await _authRepository.ping();
    } catch (e) {
      rethrow;
    }
  }
}
