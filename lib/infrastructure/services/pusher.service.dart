import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

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
  static PusherService? _singleton;
  final String token;

  PusherService._({required this.token});

  final PusherChannelsFlutter client = PusherChannelsFlutter();
  final PusherRepository pusherRepository = PusherRepository();

  final config = PusherConfig.init();

  factory PusherService.init(String token) {
    if (_singleton == null || _singleton?.token != token) {
      _singleton = PusherService._(token: token);
    }
    return _singleton!;
  }

  static Future<PusherService> initialize(String token) async {
    final service = PusherService.init(token);
    await service.client.init(
      apiKey: service.config.key!,
      cluster: service.config.cluster!,
      authParams: {
        'headers': {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      },
      onAuthorizer: (channelName, socketId, options) async {
        final response = await service.pusherRepository.authenticate(
          token: token,
          socketId: socketId,
          channelName: channelName,
          endPoint: service.config.hostAuthEndPoint,
        );
        return response.auth!;
      },
      onSubscriptionSucceeded: (channelName, data) {
        log('Subscribed to $channelName');
      },
      logToConsole: true,
    );

    return service;
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
