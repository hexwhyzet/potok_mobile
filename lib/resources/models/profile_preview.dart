import 'dart:developer';

import 'package:potok/resources/models/avatar.dart';

class ProfilePreview {
  final int id;
  final String? screenName;
  final bool isYours;
  final bool isAvailable;
  final bool isPrivate;
  final bool isLikedPicturesPageAvailable;
  final int blockStatus;
  final int subscriptionStatus;
  final Avatar avatar;

  ProfilePreview({
    required this.id,
    required this.screenName,
    required this.isYours,
    required this.isAvailable,
    required this.isPrivate,
    required this.isLikedPicturesPageAvailable,
    required this.blockStatus,
    required this.subscriptionStatus,
    required this.avatar,
  });

  factory ProfilePreview.fromJson(Map<String, dynamic> json) {
    return ProfilePreview(
      id: json['id'],
      screenName: json['screen_name'],
      isYours: json['is_yours'],
      isAvailable: json['is_available'],
      isPrivate: json['is_private'],
      isLikedPicturesPageAvailable: json['is_liked_pictures_page_available'],
      blockStatus: json['block_status'],
      subscriptionStatus: json['subscription_status'],
      avatar: Avatar.fromJson(json['avatar']),
    );
  }
}
