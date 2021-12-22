import 'package:chat/chat.dart';

class LocalMessageEntity {
  late String _id;
  String get id => _id;
  String chatId;
  Message message;
  ReceiptStatus receipt;

  LocalMessageEntity(
      {required this.chatId, required this.message, required this.receipt});

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "id": message.id,
        ...message.toJson(),
        'receipt': receipt.value()
      };

  factory LocalMessageEntity.fromJson(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'],
        contents: json['contents']);

    final localMessage = LocalMessageEntity(
      chatId: json["chat_id"],
      message: message,
      receipt: EnumParsing.fromString(json['receipt']),
    );
    localMessage._id = json['id'];
    return localMessage;
  }
}
