import 'package:potok/models/action.dart';
import 'package:potok/models/comment.dart';
import 'package:potok/models/picture.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';

dynamic objectFromJson(Map<String, dynamic> json) {
  switch (json["type"]) {
    case "picture":
      {
        return Picture.fromJson(json);
      }
    case "profile":
      {
        return Profile.fromJson(json);
      }
    case "like":
      {
        return Like.fromJson(json);
      }
    case "subscription":
      {
        return Subscription.fromJson(json);
      }
    case "comment":
      {
        return Comment.fromJson(json);
      }
  }
}

List<dynamic> objectsFromJson(List<dynamic> list) {
  List<dynamic> answer = [];
  for (var json in list) {
    answer.add(objectFromJson(json));
  }
  return answer;
}

Future<List<dynamic>> fetchObjects(String url) async {
  final response = await getRequest(url);
  return objectsFromJson(response.jsonContent);
}
