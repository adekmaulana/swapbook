import '../../../data/dto/chat.response.dart';
import '../../../data/repositories/chat.repository.dart';

class GetChatCase {
  final ChatRepository _chatRepository = ChatRepository();

  Future<ChatResponse> call(int chatId) async {
    try {
      return await _chatRepository.getChat(chatId);
    } catch (e) {
      rethrow;
    }
  }
}
