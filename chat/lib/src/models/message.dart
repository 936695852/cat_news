class Message {
  String? get id => _id;
  String? _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String contents;

  Message({
    required this.from,
    required this.to,
    required this.timestamp,
    required this.contents,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
      from: json["from"],
      to: json["to"],
      timestamp: json["timestamp"],
      contents: json["contents"],
    );
    message._id = json["id"];
    return message;
  }

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'timestamp': timestamp,
        'contents': contents,
      };
}
