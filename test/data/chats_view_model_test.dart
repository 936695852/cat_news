import 'package:cat_news/common/data/datasources/datasource_contract.dart';
import 'package:cat_news/common/data/viewmodels/chats_view_model.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_view_model_test.mocks.dart';

@GenerateMocks([IDatasource])
void main() {
  IDatasource mockDatasource = MockIDatasource();
  late ChatsViewModel sut;

  setUp(() {
    sut = ChatsViewModel(mockDatasource);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockDatasource.findAllChats()).thenAnswer((_) async => []);
    expect(await sut.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    final chat = ChatEntity('123');
    when(mockDatasource.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut.getChats();
    expect(chats, isNotEmpty);
  });

  test('create a new chat when receiving messages for the frist time',
      () async {
    when(mockDatasource.findChat(any)).thenAnswer((_) async => null);
    await sut.receivedMessage(message);
    verify(mockDatasource.addChat(any)).called(1);
  });

  test('add new message to existing chat', () async {
    final chat = ChatEntity('123');

    when(mockDatasource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });
}
