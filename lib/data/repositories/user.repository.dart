import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;

import '../../domain/interfaces/user.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/base.response.dart';
import '../dto/user.response.dart';

class UserRepository extends IUserRepository {
  final ApiService _apiservice = Get.find<ApiService>();

  @override
  Future<UserResponse> getMe(String id) async {
    try {
      final response = await _apiservice.get(AppUrl.user);

      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserResponse> updateUser(FormData data) async {
    try {
      final response = await _apiservice.post(
        AppUrl.user,
        data: data,
      );

      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> updateLocation(FormData data) async {
    try {
      final response = await _apiservice.post(
        '${AppUrl.user}/location',
        data: data,
      );

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
