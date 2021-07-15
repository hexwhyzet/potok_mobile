import 'package:potok/models/objects.dart';
import 'package:potok/models/response.dart';

class ProfileAttachment {
  final String tag;
  final String url;

  ProfileAttachment({
    required this.tag,
    required this.url,
  });

  factory ProfileAttachment.fromJson(Map<String, dynamic> json) {
    return ProfileAttachment(
      tag: json['tag'],
      url: json['url'],
    );
  }
}