import 'package:cat_news/common/data/datasources/datasource_contract.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseViewModel {
  final IDatasource _datasource;

  BaseViewModel(this._datasource);

  @protected
  Future<void> addMessage(LocalMessageEntity message) async {
    if (!await _isExistingChat(message.chatId)) {
      await _createNewChat(message.chatId);
    }
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = ChatEntity(chatId);
    await _datasource.addChat(chat);
  }
}
