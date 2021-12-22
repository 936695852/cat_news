import 'package:cat_news/common/data/datasources/datasource_contract.dart';
import 'package:cat_news/common/data/viewmodels/base_view_model.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:chat/chat.dart';

class ChatsViewModel extends BaseViewModel {
  final IDatasource _datasource;
  ChatsViewModel(this._datasource) : super(_datasource);

  Future<List<ChatEntity>> getChats() async => await _datasource.findAllChats();

  Future<void> receivedMessage(Message message) async {
    LocalMessageEntity localMessage = LocalMessageEntity(
      chatId: message.from,
      message: message,
      receipt: ReceiptStatus.delivered,
    );

    await addMessage(localMessage);
  }
}
