import 'package:cat_news/common/entities/entities.dart';

abstract class IDatasource {
  Future<void> addChat(ChatEntity? chat);
  Future<void> addMessage(LocalMessageEntity? message);
  Future<ChatEntity?> findChat(String? chatId);
  Future<List<ChatEntity>> findAllChats();
  Future<void> updateMessage(LocalMessageEntity message);
  Future<List<LocalMessageEntity>> findMessages(String? chatId);
  Future<void> deleteChat(String chatId);
}
