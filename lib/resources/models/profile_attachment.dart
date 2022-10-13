class ProfileAttachment {
  final int id;
  final String url;
  final String tag;

  ProfileAttachment({
    required this.id,
    required this.url,
    required this.tag,
  });

  factory ProfileAttachment.fromJson(Map<String, dynamic> json) {
    return ProfileAttachment(
      id: json['id'],
      url: json['url'],
      tag: json['tag'],
    );
  }
}
