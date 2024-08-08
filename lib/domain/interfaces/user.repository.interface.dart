import 'package:dio/dio.dart';

import '../../data/dto/base.response.dart';
import '../../data/dto/search_user.response.dart';
import '../../data/dto/user.response.dart';

abstract class IUserRepository {
  Future<UserResponse> getMe(String id);
  Future<UserResponse> updateUser(FormData data);
  Future<BaseResponse> updateLocation(FormData data);
  Future<SearchUserResponse> searchUser(String name);
}
