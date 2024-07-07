import 'package:get/get.dart';

import '../../domain/interfaces/auth.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/base.response.dart';
import '../dto/user.response.dart';

class AuthRepository implements IAuthRepository {
  static final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<UserResponse> login(
    String email,
    String password,
    String deviceName,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.login,
        data: {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      );

      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserResponse> loginGoogle(
    String name,
    String email,
    String googleId,
    String deviceName,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.loginGoogle,
        data: {
          'name': name,
          'email': email,
          'google_id': googleId,
          'device_name': deviceName,
        },
      );

      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> logout() async {
    try {
      final response = await _apiService.post(AppUrl.logout);

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        AppUrl.forgotPassword,
        queryParameters: {
          'email': email,
        },
      );

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
