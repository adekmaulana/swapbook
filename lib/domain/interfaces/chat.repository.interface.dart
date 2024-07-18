import '../../data/dto/chat.response.dart';
import '../../data/dto/chats.response.dart';

abstract class IChatRepository {
  Future<ChatsResponse> getChats({
    required int page,
    int limit = 10,
  });
  Future<ChatResponse> getChat(int chatId);
  Future<ChatResponse> createChat(int userId);
}
