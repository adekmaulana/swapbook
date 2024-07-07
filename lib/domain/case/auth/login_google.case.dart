import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../../../data/dto/user.response.dart';
import '../../../data/repositories/auth.repository.dart';

class AuthLoginGoogleCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserResponse> call(
    Cookie? csrfCookie,
    String name,
    String email,
    String googleId,
  ) async {
    var deviceName = await DeviceInfoPlugin().deviceInfo;
    try {
      return await _authRepository.loginGoogle(
        csrfCookie,
        name,
        email,
        googleId,
        deviceName.data['name'] ?? 'Unknown',
      );
    } catch (e) {
      rethrow;
    }
  }
}
