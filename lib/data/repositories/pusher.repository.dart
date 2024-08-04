import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../domain/interfaces/pusher.repository.interface.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/pusher_auth.response.dart';

class PusherRepository implements IPusherRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<PusherAuthResponse> authenticate({
    required String token,
    required String socketId,
    required String channelName,
    required String endPoint,
  }) async {
    final response = await _apiService.post(
      endPoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'socket_id': socketId,
          'channel_name': channelName,
        },
      ),
      queryParameters: {
        'socket_id': socketId,
        'channel_name': channelName,
      },
      data: {
        'socket_id': socketId,
        'channel_name': channelName,
      },
    );

    return PusherAuthResponse.fromJson(response.data);
  }
}
