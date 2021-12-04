enum Typing { start, stop }

extension TypingParsing on Typing {
  String value() {
    return toString().split('.').last;
    // ReceiptStatus.sent
  }

  static Typing fromString(String status) {
    return Typing.values.firstWhere((element) => element.value() == status);
  }
}

class TypingEvent {
  final String from;
  final String to;
  final Typing event;
  final String? id;

  TypingEvent({
    required this.from,
    required this.to,
    required this.event,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'event': event,
      };

  factory TypingEvent.fromJson(Map<String, dynamic> json) => TypingEvent(
        from: json["from"],
        to: json["to"],
        event: json["event"],
        id: json["id"],
      );
}
