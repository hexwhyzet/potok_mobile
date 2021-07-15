import 'package:potok/models/objects.dart';
import 'package:potok/models/profile_attachment.dart';
import 'package:potok/models/response.dart';

class Profile {
  final String avatarUrl;
  final String type;
  final bool isPublic;
  final bool areLikedPicturesPublic;
  final bool isUserBlockedByYou;
  final bool areYouBlockedByUser;
  final bool isProfileAvailable;
  final bool areLikedPicturesAvailable;
  final String name;
  final String description;
  final String screenName;
  bool isSubscribed;
  final String subscribeUrl;
  int followersNum;
  int subsNum;
  int likesNum;
  int viewsNum;
  int id;
  bool isYours;
  final String getShareUrl;
  final String reloadUrl;
  final String blockUrl;
  final List<dynamic> attachments;

  Profile({
    required this.avatarUrl,
    required this.type,
    required this.isPublic,
    required this.areLikedPicturesPublic,
    required this.isUserBlockedByYou,
    required this.areYouBlockedByUser,
    required this.isProfileAvailable,
    required this.areLikedPicturesAvailable,
    required this.name,
    required this.description,
    required this.id,
    required this.screenName,
    required this.isSubscribed,
    required this.subscribeUrl,
    required this.followersNum,
    required this.subsNum,
    required this.likesNum,
    required this.viewsNum,
    required this.isYours,
    required this.reloadUrl,
    required this.blockUrl,
    required this.getShareUrl,
    required this.attachments,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      type: json['type'],
      isPublic: json['is_public'],
      areLikedPicturesPublic: json['are_liked_pictures_public'],
      isUserBlockedByYou: json['is_user_blocked_by_you'],
      areYouBlockedByUser: json['are_you_blocked_by_user'],
      isProfileAvailable: json['is_profile_available'],
      areLikedPicturesAvailable: json['are_liked_pictures_available'],
      name: json['name'],
      attachments: objectsFromJson(json['attachments']),
      description: json['description'],
      screenName: json['screen_name'],
      avatarUrl: json['avatar_url'],
      isSubscribed: json['is_subscribed'],
      subscribeUrl: json['subscribe_url'],
      followersNum: json['followers_num'],
      subsNum: json['subs_num'],
      likesNum: json['likes_num'],
      viewsNum: json['views_num'],
      isYours: json['is_yours'],
      blockUrl: json['block_url'],
      reloadUrl: json['reload_url'],
      getShareUrl: json['share_url'],
    );
  }
}
