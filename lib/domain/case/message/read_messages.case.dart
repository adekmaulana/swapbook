import '../../../data/dto/base.response.dart';
import '../../../data/repositories/message.repository.dart';

class ReadMessagesCase {
  final MessageRepository _messageRepository = MessageRepository();

  Future<BaseResponse> call(int chatId) async {
    try {
      return await _messageRepository.readMessages(chatId);
    } catch (e) {
      rethrow;
    }
  }
}
