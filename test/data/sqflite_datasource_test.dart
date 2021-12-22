import 'package:cat_news/common/data/datasources/sqflite_datasource.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_datasource_test.mocks.dart';

@GenerateMocks([Database, Batch])
void main() {
  late SqfliteDatasource sut;
  late MockDatabase database;
  late MockBatch batch;

  setUp(() {
    database = MockDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('should perform insert of chat to database', () async {
    final chat = ChatEntity('1234');
    when(database.insert('chats', chat.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    await sut.addChat(chat);

    verify(database.insert('chats', chat.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform insert of messages to the database', () async {
    final localMessage = LocalMessageEntity(
      chatId: '1234',
      message: message,
      receipt: ReceiptStatus.sent,
    );

    when(database.insert(
      'messages',
      localMessage.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).thenAnswer((_) async => 1);

    await sut.addMessage(localMessage);

    verify(database.insert(
      'messages',
      localMessage.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).called(1);
  });

  // find messages
  test('should perform a database query and return messages', () async {
    final messagesMap = [
      {
        'chat_id': '111',
        'id': '4444',
        'from': '111',
        'to': '222',
        'contents': 'hey',
        'receipt': 'sent',
        'timestamp': DateTime.parse("2021-04-01"),
      }
    ];
    when(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);

    var messages = await sut.findMessages('111');

    expect(messages.length, 1);
    expect(messages.first.chatId, '111');

    verify(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).called(1);
  });

  test('should perform database update on messages', () async {
    //arrange
    final localMessage = LocalMessageEntity(
      chatId: '1234',
      message: message,
      receipt: ReceiptStatus.sent,
    );
    when(database.update('messages', localMessage.toJson(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    //act
    await sut.updateMessage(localMessage);

    //assert
    verify(database.update('messages', localMessage.toJson(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform database batch delete of chat', () async {
    //arrange
    const chatId = '111';
    when(database.batch()).thenReturn(batch);
    when(batch.commit(noResult: true)).thenAnswer((_) async => []);

    //act
    await sut.deleteChat(chatId);

    verify(database.batch()).called(1);
    verify(batch.commit(noResult: true)).called(1);
  });
}
