import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';

class Picture {
  final String lowResUrl;
  final String midResUrl;
  final String highResUrl;
  final String linkUrl;
  final String type;
  int likesNum;
  int viewsNum;
  int commentsNum;
  int sharesNum;
  final int id;
  final String likeUrl;
  final String addCommentUrl;
  final Profile profile;
  final bool isLiked;
  final String getShareUrl;
  final String reportUrl;
  final String deleteUrl;
  final bool canBeDeleted;

  Picture({
    this.lowResUrl,
    this.midResUrl,
    this.highResUrl,
    this.linkUrl,
    this.type,
    this.likesNum,
    this.id,
    this.likeUrl,
    this.addCommentUrl,
    this.profile,
    this.viewsNum,
    this.commentsNum,
    this.sharesNum,
    this.isLiked,
    this.getShareUrl,
    this.deleteUrl,
    this.reportUrl,
    this.canBeDeleted,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      type: json['type'],
      lowResUrl: json['low_res_url'],
      midResUrl: json['mid_res_url'],
      highResUrl: json['high_res_url'],
      linkUrl: json['link_url'],
      likesNum: json['likes_num'],
      viewsNum: json['views_num'],
      commentsNum: json['comments_num'],
      sharesNum: json['shares_num'],
      likeUrl: json['like_url'],
      addCommentUrl: json['add_comment_url'],
      isLiked: json['is_liked'],
      getShareUrl: json['share_url'],
      reportUrl: json['report_url'],
      deleteUrl: json['delete_url'],
      canBeDeleted: json['can_be_deleted'],
      profile: Profile.fromJson(json['profile']),
    );
  }

  factory Picture.formResponse(Response request) {
    return Picture.fromJson(request.jsonContent);
  }
}

Future<List<Picture>> fetchPictures(String url) async {
  final response = await getRequest(url: url);
  List<Picture> answer = [];
  for (final jsonObject in response.jsonContent) {
    answer.add(Picture.fromJson(jsonObject));
  }
  return answer;
}
