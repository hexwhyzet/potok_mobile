class Share {
  final url;

  Share({this.url});

  factory Share.fromJson(Map<String, dynamic> json) {
    return Share(
      url: json['url'],
    );
  }
}
