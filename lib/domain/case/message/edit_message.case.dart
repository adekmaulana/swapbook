import '../../../data/dto/message.response.dart';
import '../../../data/repositories/message.repository.dart';

class EditMessageCase {
  final MessageRepository _messageRepository = MessageRepository();

  Future<MessageResponse> call(
    int messageId,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _messageRepository.editMessage(
        messageId,
        data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
