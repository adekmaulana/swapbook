import '../../data/dto/pusher_auth.response.dart';

abstract class IPusherRepository {
  Future<PusherAuthResponse> authenticate({
    required String token,
    required String socketId,
    required String channelName,
    required String endPoint,
  });
}
