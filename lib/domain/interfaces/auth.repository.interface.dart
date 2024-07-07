import 'dart:io';

import 'package:dio/dio.dart';

import '../../data/dto/base.response.dart';
import '../../data/dto/user.response.dart';

abstract class IAuthRepository {
  Future<Response<dynamic>> csrfCookie();
  Future<UserResponse> login(
    Cookie? csrfCookie,
    String email,
    String password,
    String deviceName,
  );
  Future<UserResponse> loginGoogle(
    Cookie? csrfCookie,
    String name,
    String email,
    String googleId,
    String deviceName,
  );
  Future<BaseResponse> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  );
  Future<BaseResponse> logout();
  Future<BaseResponse> forgotPassword(String email);
}
