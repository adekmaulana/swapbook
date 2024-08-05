import 'package:get/get.dart';

import '../../domain/interfaces/chat.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/chat.response.dart';
import '../dto/chats.response.dart';

class ChatRepository implements IChatRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ChatsResponse> getChats({
    required int page,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.chats,
        data: {
          'page': page,
          'page_size': pageSize,
        },
      );

      return ChatsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatResponse> getChat(int chatId) async {
    try {
      final response = await _apiService.get(
        '${AppUrl.chat}/$chatId',
      );

      return ChatResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatResponse> createChat(int userId) async {
    try {
      final response = await _apiService.post(
        AppUrl.chat,
        data: {
          'user_id': userId,
        },
      );

      return ChatResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
