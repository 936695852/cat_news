class User {
  String? get id => _id;
  String? _id;
  final String username;
  final String photoUrl;
  final bool active;
  final DateTime lastSeen;

  User({
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastSeen,
  });

  toJson() => {
        'username': username,
        'photo_url': photoUrl,
        'active': active,
        'lastSeen': lastSeen
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json["username"],
      photoUrl: json["photo_url"],
      active: json["active"],
      lastSeen: json["lastSeen"],
    );
    user._id = json["id"];

    return user;
  }
}
