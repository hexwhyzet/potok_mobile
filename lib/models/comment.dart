import 'package:potok/models/picture.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';

class Comment {
  final String type;
  final int id;
  final Profile profile;
  final Picture picture;
  final String text;
  final String likeUrl;
  int likesNum;
  final int date;
  bool isLiked;
  final bool isLikedByCreator;
  final String deleteUrl;
  final bool canBeDeleted;

  Comment({
    this.type,
    this.id,
    this.profile,
    this.picture,
    this.text,
    this.likeUrl,
    this.likesNum,
    this.date,
    this.isLiked,
    this.isLikedByCreator,
    this.deleteUrl,
    this.canBeDeleted,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      type: json["type"],
      id: json["id"],
      profile: Profile.fromJson(json["profile"]),
      picture: Picture.fromJson(json["picture"]),
      text: json["text"],
      likeUrl: json["like_url"],
      likesNum: json["likes_num"],
      isLiked: json["is_liked"],
      isLikedByCreator: json["is_liked_by_creator"],
      date: json["date"],
      deleteUrl: json["delete_url"],
      canBeDeleted: json["can_be_deleted"],
    );
  }

  factory Comment.formResponse(Response request) {
    return Comment.fromJson(request.jsonContent);
  }
}

Future<List<Picture>> fetchPictures(String url) async {
  final response = await getRequest(url);
  List<Picture> answer = [];
  for (final jsonObject in response.jsonContent) {
    answer.add(Picture.fromJson(jsonObject));
  }
  return answer;
}
