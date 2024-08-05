import '../../../data/dto/messages.response.dart';
import '../../../data/repositories/message.repository.dart';

class GetMessagesCase {
  final MessageRepository _messageRepository = MessageRepository();

  Future<MessagesResponse> call(
    int chatId,
    int page,
    int pageSize,
  ) async {
    try {
      return await _messageRepository.getMessages(
        chatId: chatId,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      rethrow;
    }
  }
}
