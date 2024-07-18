import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../data/dto/pusher_auth.response.dart';
import '../../data/repositories/pusher.repository.dart';

class PusherConfig {
  String? appId;
  String? key;
  String? secret;
  String? cluster;
  String hostEndPoint = "";
  String hostAuthEndPoint = "";

  PusherConfig({
    this.appId,
    this.key,
    this.secret,
    this.cluster,
    this.hostEndPoint = '',
    this.hostAuthEndPoint = '',
  });

  static PusherConfig init() {
    final json = {
      'appId': dotenv.env['PUSHER_APP_ID'],
      'key': dotenv.env['PUSHER_KEY'],
      'secret': dotenv.env['PUSHER_SECRET'],
      'cluster': dotenv.env['PUSHER_CLUSTER'],
      'hostEndPoint': dotenv.env['PUSHER_HOST_ENDPOINT'],
      'hostAuthEndPoint': dotenv.env['PUSHER_HOST_AUTH_ENDPOINT'],
    };
    return PusherConfig.fromJson(json);
  }

  factory PusherConfig.fromJson(Map<String, dynamic> json) {
    return PusherConfig(
      appId: json['appId'],
      key: json['key'],
      secret: json['secret'],
      cluster: json['cluster'],
      hostEndPoint: json['hostEndPoint'],
      hostAuthEndPoint: json['hostAuthEndPoint'],
    );
  }
}

class PusherService extends GetxService {
  static final PusherService instance = PusherService._();
  PusherService._();

  final PusherChannelsFlutter pusher = PusherChannelsFlutter();
  final PusherRepository pusherRepository = PusherRepository();

  final _config = PusherConfig.init();

  Future<void> init() async {
    try {
      await pusher.init(
        apiKey: _config.key!,
        cluster: _config.cluster!,
        onAuthorizer: onAuth,
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  Future<PusherAuthResponse?> onAuth(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    final response = await pusherRepository.authenticate(
      socketId: socketId,
      channelName: channelName,
      endPoint: _config.hostAuthEndPoint,
    );

    return response;
  }

  Future<void> subscribeChat(int chatId) async {
    await pusher.subscribe(
      channelName: 'chat.$chatId',
      onEvent: (event) {
        log('Event: $event');
      },
    );
  }

  static const String connected = 'CONNECTED';
  static const String disconnected = 'DISCONNECTED';
}

class EchoService extends GetxService {
  static EchoService? _singleton;
  static late Echo? _echo;
  final String token;

  EchoService._({required this.token}) {
    _echo = initialize(token);
  }

  static Echo get instance => _echo!;
  static String get socketId => _echo!.socketId ?? '1111.1111';

  factory EchoService.init(String token) {
    if (_singleton == null || _singleton?.token != token) {
      _singleton = EchoService._(token: token);
    }
    return _singleton!;
  }

  Echo initialize(String token) {
    final config = PusherConfig.init();
    return Echo.pusher(
      config.key!,
      authEndPoint: config.hostAuthEndPoint,
      host: config.hostEndPoint,
      authHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      cluster: config.cluster,
      enableLogging: true,
    );
  }
}
