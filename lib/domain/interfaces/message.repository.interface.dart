import '../../data/dto/base.response.dart';
import '../../data/dto/message.response.dart';
import '../../data/dto/messages.response.dart';

abstract class IMessageRepository {
  Future<MessageResponse> editMessage(
    int messageId,
    Map<String, dynamic> data,
  );
  Future<MessageResponse> sendMessage(
    int chatId,
    String content,
    String? socketId, {
    Map<String, dynamic>? data,
    required String type,
  });
  Future<MessageResponse> getMessage(int messageId);
  Future<MessagesResponse> getMessages({
    required int chatId,
    required int page,
    int pageSize = 10,
  });
  Future<BaseResponse> readMessages(int chatId);
}
