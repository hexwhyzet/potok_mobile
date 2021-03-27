import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:potok/globals.dart';

const GREY = Color.fromRGBO(105, 105, 105, 1);
const SEMI_GREY = Color.fromRGBO(150, 150, 150, 1);
const LIGHT_GREY = Color.fromRGBO(190, 190, 190, 1);
const SUPER_LIGHT_GREY = Color.fromRGBO(247, 247, 247, 1);
const BLACK = Colors.black;
const WHITE = Colors.white;
const BLUE = Color.fromRGBO(20, 133, 255, 1);
const RED = Color.fromRGBO(255, 18, 57, 0.9);

const DARK_GREY = Color.fromRGBO(15, 15, 15, 1);

abstract class Theme {
  get colors;

  get icons;

  get texts;

  get input;
}

class LightTheme implements Theme {
  @override
  get colors => LightColors();

  @override
  get icons => LightIcons();

  @override
  get texts => LightTexts();

  @override
  get input => LightInput();
}

class DarkTheme implements Theme {
  @override
  get colors => DarkColors();

  @override
  get icons => DarkIcons();

  @override
  get texts => DarkTexts();

  @override
  get input => LightInput();
}

class LightColors {
  var secondaryColor = BLUE;

  var attentionColor = RED;

  var appBarColor = WHITE;
  var backgroundColor = SUPER_LIGHT_GREY;

  var pictureViewerBackgroundColor = BLACK;
  var pictureViewerUpperShadowUpper = Color.fromRGBO(0, 0, 0, 0.55);
  var pictureViewerUpperShadowLower = Colors.transparent;
  var pictureViewerLowerShadowUpper = Colors.transparent;
  var pictureViewerLowerShadowLower = Color.fromRGBO(0, 0, 0, 0.35);
  var pictureViewerSubscribeBubble = BLUE;
  var pictureViewerCross = Colors.white;
  var pictureViewerCommentSection = DARK_GREY;

  var activityAvatarOutline = GREY;

  var profileAvatarOutline = LIGHT_GREY;
  var profileEmptyPicture = LIGHT_GREY;
  var profileButtonOutline = LIGHT_GREY.withOpacity(0.5);
  var profileTabBarIndicator = BLACK;
}

class DarkColors {
  var backgroundColor = Colors.white;

  var pictureViewerBackgroundColor = BLACK;
  var pictureViewerUpperShadowUpper = Color.fromRGBO(0, 0, 0, 0.55);
  var pictureViewerUpperShadowLower = Colors.transparent;
  var pictureViewerLowerShadowUpper = Colors.transparent;
  var pictureViewerLowerShadowLower = Color.fromRGBO(0, 0, 0, 0.35);

  var activityAvatarOutline = GREY;

  var profileAvatarOutline = GREY;
  var profileEmptyPicture = LIGHT_GREY;
  var profileButtonOutline = LIGHT_GREY;
  var profileTabBarIndicator = BLACK;
}

class LightIcons {
  var backArrow = IconThemeData(
    color: BLACK,
    size: 40,
  );

  var morePeriods = IconThemeData(
    color: BLACK,
    size: 31,
  );

  var pictureViewerBackArrow = IconThemeData(
    color: WHITE,
    size: 40,
  );

  var pictureViewerLikeUnPressed = IconThemeData(
    color: WHITE,
    size: 33,
    opacity: 0.85,
  );

  var pictureViewerLikePressed = IconThemeData(
    color: RED,
    size: 33,
  );

  var pictureViewerComment = IconThemeData(
    color: WHITE,
    size: 33,
    opacity: 0.85,
  );

  var pictureViewerShare = IconThemeData(
    color: WHITE,
    size: 26,
    opacity: 0.85,
  );

  var pictureViewerMore = IconThemeData(color: WHITE, size: 35, opacity: 0.85);

  var profileTabBar = IconThemeData(
    color: BLACK,
    size: 34,
  );

  var commentHeartUnpressed = IconThemeData(
    color: GREY,
    size: 26,
  );

  var commentHeartPressed = IconThemeData(
    color: RED,
    size: 26,
  );

  var settingsArrow = IconThemeData(
    color: BLACK,
    size: 26,
  );
}

class DarkIcons {
  var backArrow = IconThemeData(
    color: BLACK,
    size: 40,
  );

  var pictureViewerLikeUnPressed = IconThemeData(
    color: LIGHT_GREY,
    size: 33,
    opacity: 0.9,
  );

  var pictureViewerLikePressed = IconThemeData(
    color: RED,
    size: 33,
  );

  var pictureViewerShare = IconThemeData(
    color: LIGHT_GREY,
    size: 28,
    opacity: 0.9,
  );

  var profileTabBar = IconThemeData(
    color: BLACK,
    size: 34,
  );
}

class LightTexts {
  TextStyle header = TextStyle(
    fontFamily: "Sofia",
    color: Colors.black,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  TextStyle body = TextStyle(
    fontFamily: "Sofia",
    color: GREY,
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );

  TextStyle inputHint =
      TextStyle(fontFamily: "Sofia", fontSize: 19, color: Colors.grey);

  TextStyle homeScreenAppBarSelected = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  TextStyle homeScreenAppBarUnSelected = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE.withOpacity(0.6),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  TextStyle bottomNavigationBarSelected = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerBottomNavigationBarSelected = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerButton = TextStyle(
    fontFamily: 'Sofia',
    color: Colors.white.withOpacity(0.4),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle bottomNavigationBarUnSelected = TextStyle(
    fontFamily: 'Sofia',
    color: GREY.withOpacity(0.7),
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerBottomNavigationBarUnSelected = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerScreenName = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentUpBar = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentAuthor = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    height: 1,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentText = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 15,
    height: 1.1,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentDate = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentHeartLabel = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 13,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentSection = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureViewerCommentSectionDark = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle emptyPictureViewer = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 18,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle yourCommentStatic = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle yourComment = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle yourCommentDark = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
  );

  TextStyle profileScreenName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileScreenNameYours = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  TextStyle appBarSettings = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 23,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    height: 1,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileStatsLabel = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 14.5,
    height: 1,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileBlockText = TextStyle(
    fontFamily: 'Sofia',
    color: RED,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileStatsNumber = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 18.5,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileDescription = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    height: 1.1,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  TextStyle profileButtonSubscribed = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileButtonUnSubscribed = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle pictureViewerToolbarLabel = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE.withOpacity(0.85),
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  TextStyle uploadButton = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 19,
    fontWeight: FontWeight.w500,
  );

  TextStyle activity = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  TextStyle activityTime = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureDescription = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE.withOpacity(0.9),
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureName = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE.withOpacity(0.9),
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  TextStyle profilePictureViews = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE.withOpacity(0.9),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle searchProfileScreenName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    height: 1,
    fontWeight: FontWeight.w500,
  );
  TextStyle searchProfileName = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w500,
  );
  TextStyle searchProfileStats = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w500,
  );
  TextStyle searchProfileSuggestion = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle profilePrivacyMessageHeader = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profilePrivacyMessageText = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  TextStyle searchHint = TextStyle(
    fontFamily: 'Sofia',
    color: SEMI_GREY,
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );
  TextStyle searchText = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );
  TextStyle flushbar = TextStyle(
    fontFamily: "Sofia",
    fontSize: 16,
    height: 1.35,
    color: Colors.white,
  );

  TextStyle uploadEULALink = TextStyle(
    fontFamily: 'Sofia',
    color: BLUE,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle editProfileButton = TextStyle(
    fontFamily: 'Sofia',
    color: SEMI_GREY,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle settingsHeader = TextStyle(
    fontFamily: 'Sofia',
    color: SEMI_GREY,
    fontSize: 19,
    fontWeight: FontWeight.w500,
  );

  TextStyle settingsTile = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  TextStyle settingsInput = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle cropPictureButton = TextStyle(
    fontFamily: 'Sofia',
    color: WHITE,
    fontSize: 19,
    fontWeight: FontWeight.w600,
  );

  TextStyle searchEmptyQuery = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  TextStyle emptyCommentSection = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  TextStyle emptyActionsPage = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  TextStyle errorRegistration = TextStyle(
    fontFamily: 'Sofia',
    color: RED,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle registrationScreen = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  TextStyle registrationVerificationLabel = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  TextStyle registrationVerificationCode = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
}

class DarkTexts {
  TextStyle homeScreenAppBarSelected = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );

  TextStyle homeScreenAppBarUnSelected = TextStyle(
    fontFamily: 'Sofia',
    color: GREY.withOpacity(0.5),
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );

  TextStyle bottomNavigationBarSelected = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle bottomNavigationBarUnSelected = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle profileScreenName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 21,
    fontWeight: FontWeight.w400,
  );

  TextStyle profileScreenNameYours = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 26,
    fontWeight: FontWeight.w600,
  );

  TextStyle pictureViewerName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileStatsLabel = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileStatsNumber = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileName = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileButtonSubscribed = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle profileButtonUnSubscribed = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  TextStyle pictureViewerToolbarLabel = TextStyle(
    fontFamily: 'Sofia',
    color: LIGHT_GREY,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  TextStyle uploadButton = TextStyle(
    fontFamily: 'Sofia',
    color: BLACK,
    fontSize: 19,
    fontWeight: FontWeight.w500,
  );

  TextStyle activity = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  TextStyle pictureDescription = TextStyle(
    fontFamily: 'Sofia',
    color: GREY,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
}

class LightInput {
  InputDecoration input = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    filled: true,
    alignLabelWithHint: true,
    fillColor: Color.fromRGBO(235, 235, 235, 1),
    border: OutlineInputBorder(),
    labelText: 'Label text',
    labelStyle: theme.texts.inputHint,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: EdgeInsets.all(13),
  );
}
