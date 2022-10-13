
class Like {
  final String type;
  final Profile profile;
  final Picture picture;
  final int date;

  Like({
    required this.type,
    required this.profile,
    required this.picture,
    required this.date,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      type: json['type'],
      profile: Profile.fromJson(json['profile']),
      picture: Picture.fromJson(json['picture']),
      date: json['date'],
    );
  }

  factory Like.formResponse(Response request) {
    return Like.fromJson(request.jsonContent);
  }
}

class Subscription {
  final String type;
  final Profile profile;
  final int date;

  Subscription({
    required this.type,
    required this.profile,
    required this.date,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      type: json['type'],
      profile: Profile.fromJson(json['profile']),
      date: json['date'],
    );
  }

  factory Subscription.formResponse(Response request) {
    return Subscription.fromJson(request.jsonContent);
  }
}
