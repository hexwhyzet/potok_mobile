class Token {
  String token;
  bool isAnonymous;

  Token({required this.token, required this.isAnonymous});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      isAnonymous: json['is_anonymous'],
    );
  }
}