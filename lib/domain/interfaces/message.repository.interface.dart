import '../../data/dto/message.response.dart';
import '../../data/dto/messages.response.dart';

abstract class IMessageRepository {
  Future<MessageResponse> sendMessage(int chatId, String content);
  Future<MessageResponse> getMessage(int messageId);
  Future<MessagesResponse> getMessages({
    required int chatId,
    required int page,
    int limit = 10,
  });
}
