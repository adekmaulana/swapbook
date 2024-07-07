import 'package:swapbook/data/models/user.model.dart';

import '../../data/dto/base.response.dart';
import '../../data/dto/user.response.dart';

abstract class IAuthRepository {
  Future<UserResponse> login(
    String email,
    String password,
    String deviceName,
  );
  Future<UserResponse> loginGoogle(
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
