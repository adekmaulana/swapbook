import '../../data/dto/chat.response.dart';
import '../../data/dto/chats.response.dart';

abstract class IChatRepository {
  Future<ChatsResponse> getChats();
  Future<ChatResponse> getChat(int chatId);
  Future<ChatResponse> createChat(int userId);
}
