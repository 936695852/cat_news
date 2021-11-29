class UserLoginRequestEntity {
  UserLoginRequestEntity({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginRequestEntity(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class UserLoginResponseEntity {
  UserLoginResponseEntity({
    this.accessToken,
    this.channels,
    this.displayName,
  });

  String? accessToken;
  List<String>? channels;
  String? displayName;

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        accessToken: json["access_token"] ?? '',
        channels: List<String>.from(json["channels"].map((x) => x)),
        displayName: json["display_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "channels":
            channels == null ? [] : List<dynamic>.from(channels!.map((x) => x)),
        "display_name": displayName,
      };
}
