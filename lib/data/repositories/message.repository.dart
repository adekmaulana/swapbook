import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../domain/interfaces/message.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../../infrastructure/services/pusher.service.dart';
import '../dto/base.response.dart';
import '../dto/message.response.dart';
import '../dto/messages.response.dart';

class MessageRepository implements IMessageRepository {
  final ApiService _apiservice = Get.find<ApiService>();

  MessageRepository() {
    _apiservice.dio.options.baseUrl = AppUrl.baseUrl;
  }

  @override
  Future<MessageResponse> editMessage(
    int messageId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiservice.post(
        '${AppUrl.message}/$messageId',
        options: Options(
          headers: {
            'X-Socket-ID': EchoService.instance.socketId,
          },
        ),
        data: data,
      );

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessageResponse> getMessage(int messageId) async {
    try {
      final response = await _apiservice.get('${AppUrl.message}/$messageId');

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessageResponse> sendMessage(
    int chatId,
    String content,
    String? socketId, {
    Map<String, dynamic>? data,
    required String type,
  }) async {
    try {
      final response = await _apiservice.post(
        AppUrl.message,
        options: Options(
          headers: {
            'X-Socket-ID': socketId,
          },
        ),
        data: {
          'chat_id': chatId,
          'content': content,
          'type': type,
          if (data != null) ...data,
        },
      );

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessagesResponse> getMessages({
    required int chatId,
    required int page,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiservice.get(
        AppUrl.messages,
        queryParameters: {
          'chat_id': chatId,
          'page': page,
          'page_size': pageSize,
        },
      );

      return MessagesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> readMessages(int chatId) async {
    try {
      final response = await _apiservice.post(
        '${AppUrl.messages}/read',
        data: {
          'chat_id': chatId,
        },
      );

      return BaseResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
