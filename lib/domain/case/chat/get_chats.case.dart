import '../../../data/dto/chats.response.dart';
import '../../../data/repositories/chat.repository.dart';

class GetChatsCase {
  final ChatRepository _chatRepository = ChatRepository();

  Future<ChatsResponse> call(
    int page,
    int pageSize,
  ) async {
    try {
      return await _chatRepository.getChats(
        page: page,
        limit: pageSize,
      );
    } catch (e) {
      rethrow;
    }
  }
}
