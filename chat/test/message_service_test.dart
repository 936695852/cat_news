import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main() {
  RethinkDb r = RethinkDb();
  late Connection connection;
  late MessageService sut; // system under test

  setUp(() async {
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    final encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(r, connection);
    sut = MessageService(r, connection, encryption);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection);
  });

  final user = User.fromJson({
    'id': '1234',
    'username': '',
    'photo_url': '',
    'active': true,
    'lastSeen': DateTime.now(),
  });
  final user2 = User.fromJson({
    'id': '1111',
    'username': '',
    'photo_url': '',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test('send message successfully', () async {
    Message message = Message(
      from: user.id!,
      to: '3456',
      timestamp: DateTime.now(),
      contents: 'this is a message',
    );

    final res = await sut.send(message);
    expect(res, true);
  });

  test('successfully subscribed and receive messages', () async {
    const contents = 'this. is a message';
    sut.messages(activeUser: user2).listen(
          expectAsync1((message) {
            expect(message.to, user2.id);
            expect(message.id, isNotEmpty);
            expect(message.contents, contents);
          }, count: 2),
        );
    Message message = Message(
      from: user.id!,
      to: user2.id!,
      timestamp: DateTime.now(),
      contents: contents,
    );

    Message secondMessage = Message(
      from: user.id!,
      to: user2.id!,
      timestamp: DateTime.now(),
      contents: contents,
    );

    await sut.send(message);
    await sut.send(secondMessage);
  });

  test('successfully subscribed and receive new messages', () async {
    const contents = 'this. is a message';
    Message message = Message(
      from: user.id!,
      to: user2.id!,
      timestamp: DateTime.now(),
      contents: contents,
    );

    Message secondMessage = Message(
      from: user.id!,
      to: user2.id!,
      timestamp: DateTime.now(),
      contents: contents,
    );

    await sut.send(message);
    await sut.send(secondMessage).whenComplete(
          () => sut.messages(activeUser: user2).listen(
                expectAsync1((message) {
                  expect(message.to, user2.id);
                  expect(message.contents, contents);
                }, count: 2),
              ),
        );
  });
}
