import '../../../data/dto/message.response.dart';
import '../../../data/repositories/message.repository.dart';

class SendMessageCase {
  final MessageRepository _messageRepository = MessageRepository();

  Future<MessageResponse> call(
    int chatId,
    String content,
    String? socketId, {
    String type = 'text',
  }) async {
    try {
      return await _messageRepository.sendMessage(
        chatId,
        content,
        socketId,
        type: type,
      );
    } catch (e) {
      rethrow;
    }
  }
}
