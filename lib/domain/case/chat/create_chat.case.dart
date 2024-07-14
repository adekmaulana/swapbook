import '../../../data/dto/chat.response.dart';
import '../../../data/repositories/chat.repository.dart';

class CreateChatCase {
  final ChatRepository _chatRepository = ChatRepository();

  Future<ChatResponse> call(int userId) async {
    try {
      return await _chatRepository.createChat(userId);
    } catch (e) {
      rethrow;
    }
  }
}
