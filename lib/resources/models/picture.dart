import 'package:equatable/equatable.dart';
import 'package:potok/resources/models/picture_data.dart';
import 'package:potok/resources/models/profile_preview.dart';

class Picture {
  final int id;
  final int date;
  final String? text;
  final String? linkUrl;
  int viewsNum;
  int likesNum;
  bool isLiked;
  int sharesNum;
  int commentsNum;
  final ProfilePreview profilePreview;
  final PictureDataManager sizes;

  Picture({
    required this.id,
    required this.date,
    this.text,
    this.linkUrl,
    required this.viewsNum,
    required this.likesNum,
    required this.isLiked,
    required this.sharesNum,
    required this.commentsNum,
    required this.profilePreview,
    required this.sizes,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    var sizesListJson = json['sizes'] as List;
    List<PictureData> sizes = List<PictureData>.from(
        sizesListJson.map((i) => PictureData.fromJson(i)));
    return Picture(
      id: json['id'],
      date: json['date'],
      text: json['text'],
      linkUrl: json['link_url'],
      viewsNum: json['views_num'],
      likesNum: json['likes_num'],
      isLiked: json['is_liked'],
      sharesNum: json['shares_num'],
      commentsNum: json['comments_num'],
      profilePreview: ProfilePreview.fromJson(json['profile_preview']),
      sizes: PictureDataManager(sizes: sizes),
    );
  }

  Picture copyWith({
    int? id,
    int? date,
    String? text,
    String? linkUrl,
    int? viewsNum,
    int? likesNum,
    bool? isLiked,
    int? sharesNum,
    int? commentsNum,
    ProfilePreview? profilePreview,
    PictureDataManager? sizes,
  }) {
    return Picture(
      id: id ?? this.id,
      date: date ?? this.date,
      text: text ?? this.text,
      linkUrl: linkUrl ?? this.linkUrl,
      viewsNum: viewsNum ?? this.viewsNum,
      likesNum: likesNum ?? this.likesNum,
      isLiked: isLiked ?? this.isLiked,
      sharesNum: sharesNum ?? this.sharesNum,
      commentsNum: commentsNum ?? this.commentsNum,
      profilePreview: profilePreview ?? this.profilePreview,
      sizes: sizes ?? this.sizes,
    );
  }
}
