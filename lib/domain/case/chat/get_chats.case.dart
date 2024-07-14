import '../../../data/dto/chats.response.dart';
import '../../../data/repositories/chat.repository.dart';

class GetChatsCase {
  final ChatRepository _chatRepository = ChatRepository();

  Future<ChatsResponse> call() async {
    try {
      return await _chatRepository.getChats();
    } catch (e) {
      rethrow;
    }
  }
}
