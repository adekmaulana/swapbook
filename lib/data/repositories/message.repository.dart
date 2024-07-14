import 'package:get/get.dart';

import '../../domain/interfaces/message.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/message.response.dart';
import '../dto/messages.response.dart';

class MessageRepository implements IMessageRepository {
  final ApiService _apiservice = Get.find<ApiService>();

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
  Future<MessageResponse> sendMessage(int chatId, String content) async {
    try {
      final response = await _apiservice.post(
        AppUrl.message,
        data: {
          'chat_id': chatId,
          'content': content,
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
    int limit = 10,
  }) async {
    try {
      final response = await _apiservice.get(
        AppUrl.messages,
        queryParameters: {
          'chat_id': chatId,
          'page': page,
          'limit': limit,
        },
      );

      return MessagesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
