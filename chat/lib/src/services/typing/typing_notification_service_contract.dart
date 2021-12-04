import 'package:chat/src/models/typeing_event.dart';
import 'package:chat/src/models/user.dart';

abstract class ITypingNotification {
  Future<bool> send({required TypingEvent event});
  Stream<TypingEvent> subscribe(User user, List<String> usersIds);
}
