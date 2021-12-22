import 'package:cat_news/common/data/datasources/datasource_contract.dart';
import 'package:cat_news/common/data/viewmodels/chat_view_model.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_view_model_test.mocks.dart';

@GenerateMocks([IDatasource])
void main() {
  IDatasource mockDatasource = MockIDatasource();
  late ChatViewModel sut;

  setUp(() {
    sut = ChatViewModel(mockDatasource);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial messages return empty list', () async {
    when(mockDatasource.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });

  test('returns list of messages form local storage', () async {
    final chat = ChatEntity('123');
    final localMessage = LocalMessageEntity(
        chatId: chat.id, message: message, receipt: ReceiptStatus.delivered);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await sut.getMessages('123');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });

  test('create a new chat when sending first message', () async {
    when(mockDatasource.findChat(any)).thenAnswer((_) async => null);
    await sut.sendMessage(message);
    verify(mockDatasource.addChat(any)).called(1);
  });

  test('add new sent message to the chat', () async {
    final chat = ChatEntity('123');
    final localMessage = LocalMessageEntity(
        chatId: chat.id, message: message, receipt: ReceiptStatus.sent);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);

    await sut.getMessages('123');
    await sut.sendMessage(message);

    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = ChatEntity('111');
    final localMessage = LocalMessageEntity(
        chatId: chat.id, message: message, receipt: ReceiptStatus.delivered);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => chat);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });

  test('creates new chat when message received is not apart of this chat',
      () async {
    final chat = ChatEntity('123');
    final localMessage = LocalMessageEntity(
        chatId: chat.id, message: message, receipt: ReceiptStatus.delivered);

    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => null);
    when(mockDatasource.findChat(any)).thenAnswer((_) async => null);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verify(mockDatasource.addChat(any)).called(1);
    verify(mockDatasource.addMessage(any)).called(1);
    expect(sut.otherMessages, 1);
  });
}
