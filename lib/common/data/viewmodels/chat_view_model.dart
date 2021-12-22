import 'package:cat_news/common/data/datasources/datasource_contract.dart';
import 'package:cat_news/common/data/viewmodels/base_view_model.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:chat/chat.dart';

class ChatViewModel extends BaseViewModel {
  final IDatasource _datasource;
  String _chatId = '';
  int otherMessages = 0;
  ChatViewModel(this._datasource) : super(_datasource);

  Future<List<LocalMessageEntity>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) {
      _chatId = chatId;
    }

    return messages;
  }

  Future<void> sendMessage(Message message) async {
    LocalMessageEntity localMessage = LocalMessageEntity(
      chatId: message.to,
      message: message,
      receipt: ReceiptStatus.sent,
    );

    if (_chatId.isNotEmpty) return await _datasource.addMessage(localMessage);

    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessageEntity localMessage = LocalMessageEntity(
      chatId: message.from,
      message: message,
      receipt: ReceiptStatus.delivered,
    );

    if (localMessage.chatId != _chatId) otherMessages++;

    await addMessage(localMessage);
  }
}
