import 'package:dio/dio.dart';

import '../../../data/repositories/auth.repository.dart';

class AuthCSRFCookieCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<Response<dynamic>> call() async {
    try {
      return await _authRepository.csrfCookie();
    } catch (e) {
      rethrow;
    }
  }
}
