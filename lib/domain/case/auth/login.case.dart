import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../../../data/dto/user.response.dart';
import '../../../data/repositories/auth.repository.dart';

class AuthLoginCase {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserResponse> call(
    Cookie? csrfCookie,
    String email,
    String password,
  ) async {
    var deviceName = await DeviceInfoPlugin().deviceInfo;
    try {
      final UserResponse userResponse = await _authRepository.login(
        csrfCookie,
        email,
        password,
        deviceName.data['name'] ?? 'Unknown',
      );

      return userResponse;
    } catch (e) {
      rethrow;
    }
  }
}
