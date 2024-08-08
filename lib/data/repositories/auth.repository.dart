import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../domain/interfaces/auth.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/base.response.dart';
import '../dto/user.response.dart';

class AuthRepository implements IAuthRepository {
  final ApiService _apiService = Get.find<ApiService>();

  AuthRepository() {
    _apiService.dio.options.baseUrl = AppUrl.baseUrl;
  }

  @override
  Future<Response<dynamic>> csrfCookie() async {
    try {
      final response = await _apiService.get(AppUrl.csrfToken);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserResponse> login(
    Cookie? csrfCookie,
    String email,
    String password,
    String deviceName,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.login,
        options: Options(
          headers: {
            'X-XSRF-TOKEN': Uri.decodeFull(csrfCookie?.value ?? ''),
          },
        ),
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
    Cookie? csrfCookie,
    String name,
    String email,
    String googleId,
    String deviceName,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.loginGoogle,
        options: Options(
          headers: {
            'X-XSRF-TOKEN': Uri.decodeFull(csrfCookie?.value ?? ''),
          },
        ),
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

  @override
  Future<BaseResponse> ping() async {
    try {
      final response = await _apiService.get(AppUrl.ping);

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
