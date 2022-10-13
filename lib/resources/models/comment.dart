import 'package:potok/resources/models/profile_preview.dart';

class Comment {
  final int id;
  final int date;
  final String text;
  final int likesNum;
  final bool isLiked;
  final int sharesNum;
  final ProfilePreview profilePreview;

  Comment({
    required this.id,
    required this.date,
    required this.text,
    required this.likesNum,
    required this.isLiked,
    required this.sharesNum,
    required this.profilePreview,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      date: json['date'],
      text: json['text'],
      likesNum: json['likes_num'],
      isLiked: json['isLiked'],
      sharesNum: json['sharesNum'],
      profilePreview: ProfilePreview.fromJson(json['profile_preview']),
    );
  }

  copyWith({
    int? likesNum,
    bool? isLiked,
    int? sharesNum,
  }) {
    return Comment(
      id: this.id,
      date: this.date,
      text: this.text,
      likesNum: likesNum ?? this.likesNum,
      isLiked: isLiked ?? this.isLiked,
      sharesNum: sharesNum ?? this.sharesNum,
      profilePreview: this.profilePreview,
    );
  }
}
