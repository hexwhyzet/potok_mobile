
import 'package:potok/resources/models/avatar.dart';
import 'package:potok/resources/models/profile_attachment.dart';

class Profile {
  final int id;
  final String? screenName;
  final String? name;
  final String? description;
  final Avatar avatar;
  final int viewsNum;
  final int likesNum;
  final int sharesNum;
  final int followersNum;
  final int followingNum;
  final bool isYours;
  final bool isAvailable;
  final bool isPrivate;
  final bool isLikedPicturesPageAvailable;
  final int blockStatus;
  final int subscriptionStatus;
  final List<ProfileAttachment> attachments;

  Profile({
    required this.id,
    required this.screenName,
    required this.name,
    required this.description,
    required this.avatar,
    required this.viewsNum,
    required this.likesNum,
    required this.sharesNum,
    required this.followersNum,
    required this.followingNum,
    required this.isYours,
    required this.isAvailable,
    required this.isPrivate,
    required this.isLikedPicturesPageAvailable,
    required this.blockStatus,
    required this.subscriptionStatus,
    required this.attachments,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      screenName: json['screen_name'],
      name: json['name'],
      description: json['description'],
      avatar: Avatar.fromJson(json['avatar']),
      viewsNum: json['views_num'],
      likesNum: json['likes_num'],
      sharesNum: json['shares_num'],
      followersNum: json['followers_num'],
      followingNum: json['leaders_num'],
      isYours: json['is_yours'],
      isAvailable: json['is_available'],
      isPrivate: json['is_private'],
      isLikedPicturesPageAvailable: json['is_liked_pictures_page_available'],
      blockStatus: json['block_status'],
      subscriptionStatus: json['subscription_status'],
      attachments: (json['attachments'] as List)
          .map((e) => ProfileAttachment.fromJson(e))
          .toList(),
    );
  }
}
