import 'package:cat_news/common/entities/chat/local_message.dart';

class ChatEntity {
  String id;
  int unread = 0;
  List<LocalMessageEntity>? messages = [];
  LocalMessageEntity? mostRecent;

  ChatEntity(this.id, {this.messages, this.mostRecent});

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  factory ChatEntity.fromJson(Map<String, dynamic> json) => ChatEntity(
        json['id'],
      );
}
