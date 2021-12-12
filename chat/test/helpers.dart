import 'package:rethink_db_ns/rethink_db_ns.dart';

initSut<T>(RethinkDb r, Connection connection) async {
  connection = await r.connect(host: "127.0.0.1", port: 28015);
  await createDb(r, connection);
}

Future<void> createDb(RethinkDb r, Connection connection) async {
  await r.tableCreate('users').run(connection).catchError((err) => {});
  await r.tableCreate('messages').run(connection).catchError((err) => {});
  await r.tableCreate('receipts').run(connection).catchError((err) => {});
  await r.tableCreate('typing_events').run(connection).catchError((err) => {});
}

Future<void> cleanDb(RethinkDb r, Connection connection) async {
  await r.table('users').delete().run(connection);
  await r.table('messages').delete().run(connection);
  await r.table('receipts').delete().run(connection);
  await r.table('typing_events').delete().run(connection);
}
