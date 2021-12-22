import 'package:cat_news/common/entities/chat/local_message.dart';

import 'package:cat_news/common/entities/chat/chat.dart';
import 'package:sqflite/sqflite.dart';

import 'datasource_contract.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;

  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(ChatEntity? chat) async {
    await _db.insert(
      'chats',
      chat != null ? chat.toJson() : {},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> addMessage(LocalMessageEntity? message) async {
    await _db.insert(
      'messages',
      message != null ? message.toJson() : {},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ChatEntity>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage = await txn.rawQuery('''
        SELECT messages.* FROM (
          SELECT
            chat_id, MAX(created_at) AS created_at
            FROM messages
            GROUP BY chat_id
        ) AS latest_messages
        INNER JOIN messages
        ON messages.chat_id = latest_messages.chat_id
        AND messages.created_at = latest_messages.created_at
      ''');

      if (chatsWithLatestMessage.isEmpty) return [];

      final chatsWithUnreadMessages = await txn.rawQuery('''
        SELECT chat_id, count(*) as unread FROM messages
        WHERE receipt = ?
        GROUP BY chat_id
      ''', ['delivered']);

      return chatsWithLatestMessage.map<ChatEntity>((row) {
        final int? unread = int.tryParse(chatsWithUnreadMessages.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread'] as String);

        final chat = ChatEntity.fromJson(row);
        chat.unread = unread!;
        chat.mostRecent = LocalMessageEntity.fromJson(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<ChatEntity?> findChat(String? chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
        'SELECT COUNT(*) ',
        [chatId, 'delivered'],
      ));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'create_at DESC',
          limit: 1);

      final chat = ChatEntity.fromJson(listOfChatMaps.first);
      chat.unread = unread ?? 0;
      chat.mostRecent = LocalMessageEntity.fromJson(mostRecentMessage.first);

      return chat;
    });
  }

  @override
  Future<List<LocalMessageEntity>> findMessages(String? chatId) async {
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessageEntity>((map) => LocalMessageEntity.fromJson(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessageEntity message) async {
    await _db.update(
      'messages',
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.message.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
