import 'dart:math';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potok/config.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/models/comment.dart';
import 'package:potok/models/functions.dart';
import 'package:potok/models/picture.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/actions_bottom_sheet.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/circle_avatar.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/profile/profile_screen.dart';
import 'package:potok/widgets/registration/registration.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionsToolbar extends StatefulWidget {
  final Picture picture;
  final bool showProfile;
  final double bottomPadding;
  final Tracker tracker;

  ActionsToolbar({
    required this.picture,
    this.bottomPadding = 0,
    this.showProfile = true,
    required this.tracker,
  });

  @override
  _ActionsToolbarState createState() => _ActionsToolbarState();
}

class _ActionsToolbarState extends State<ActionsToolbar> {
  final GlobalKey<_LikeButton> likeGlobalKey = GlobalKey();

  void actionsToolbarUpdater() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: this.widget.bottomPadding),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 10),
            child: GestureDetector(
              onDoubleTap: () {
                likeGlobalKey.currentState!.doubleTap();
              },
              child: Container(
                color: Colors.white.withOpacity(0),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: PictureDescription(picture: widget.picture),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: 370,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfilePicture(
                        profile: widget.picture.profile,
                        showProfile: this.widget.showProfile,
                      ),
                      LikeButton(
                        picture: widget.picture,
                        key: likeGlobalKey,
                        tracker: widget.tracker,
                      ),
                      CommentButton(
                        picture: widget.picture,
                        actionsToolbarUpdater: actionsToolbarUpdater,
                      ),
                      ShareButton(
                        picture: widget.picture,
                        tracker: widget.tracker,
                      ),
                      MoreButton(picture: widget.picture)
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TapAnimation extends StatelessWidget {
  Widget child;
  final AnimatorKey<double> animatorKey;

  TapAnimation({required this.child, required this.animatorKey});

  @override
  Widget build(BuildContext context) {
    return Animator<double>(
      animatorKey: animatorKey,
      tween: Tween<double>(begin: 0, end: 2),
      repeats: 1,
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
      builder: (context, animatorState, child) {
        if (animatorState.value < 1) {
          return Center(
            child: Transform.scale(
              scale: 1 - animatorState.value / 7,
              child: this.child,
            ),
          );
        } else {
          return Center(
            child: Transform.scale(
              scale: 1 - ((2 - animatorState.value) / 7),
              child: this.child,
            ),
          );
        }
      },
    );
  }
}

class PictureDescription extends StatelessWidget {
  final Picture picture;

  PictureDescription({required this.picture});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   alignment: Alignment.bottomLeft,
          //   child: Text("@${picture.profile.screenName}",
          //       style: theme.texts.pictureName),
          // ),
          if (picture.linkUrl != null)
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.grey.withOpacity(0.2),
                ),
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(6),
                child: Center(
                  child: Text("Link", style: theme.texts.pictureViewerButton),
                ),
              ),
              onTap: () async {
                if (await canLaunch("${picture.linkUrl}")) {
                  await launch("${picture.linkUrl}",
                      forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch ${picture.linkUrl}';
                }
              },
            ),
          // ConstrainedBox(
          //   constraints: BoxConstraints(),
          //   child: Container(
          //     child: Text(
          //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exer",
          //         style: theme.texts.pictureDescription),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  final Profile profile;
  final bool showProfile;

  ProfilePicture({required this.profile, this.showProfile = true});

  @override
  _ProfilePicture createState() => _ProfilePicture();
}

class _ProfilePicture extends State<ProfilePicture> {
  bool isSubscribed = false;
  late AnimatorKey<double> animatorKey;
  bool isTouched = true;
  bool isUnTouched = true;

  @override
  void initState() {
    super.initState();
    this.isSubscribed = getIsSubscribed();
    this.animatorKey = AnimatorKey<double>(
      initialValue: this.isSubscribed ? 0 : 1,
    );
  }

  bool getIsSubscribed() {
    return globals.cacher
        .checkSub(widget.profile.id, widget.profile.isSubscribed);
  }

  double scaleCurve(double value) {
    if (value > 0.85) {
      return 1 + (1 - value) * 1.5;
    } else if (value > 0.7) {
      return 1 + (value - 0.7) * 1.5;
    } else {
      return value / 0.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child:
                    CustomCircleAvatar(profile: widget.profile, radius: 22.5),
              ),
            ),
            onTap: () async {
              if (widget.showProfile) {
                await Navigator.push(
                  context,
                  createRoute(
                    ProfileScreen(
                      profile: widget.profile,
                    ),
                  ),
                );
                setState(() {
                  isUnTouched = true;
                  this.isSubscribed = getIsSubscribed();
                });
              }
            },
          ),
          if (!widget.profile.isYours)
            GestureDetector(
              onTap: () {
                if (!isSubscribed) {
                  if (!globals.isLogged) {
                    showAuthenticationScreen(context);
                    return;
                  }
                  getRequest(url: widget.profile.subscribeUrl).then((data) {
                    if (data.status == 200) {
                      setState(() {
                        this.isSubscribed = true;
                        globals.cacher.updateSub(widget.profile.id, true);
                      });
                    } else {
                      errorFlushbar("Failed to subscribe")..show(context);
                    }
                  });
                  animatorKey.triggerAnimation();
                  isUnTouched = false;
                }
              },
              child: Animator<double>(
                resetAnimationOnRebuild: false,
                animatorKey: animatorKey,
                tween: Tween<double>(begin: 1, end: 0),
                repeats: 1,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
                builder: (context, animatorState, child) {
                  return Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Transform.rotate(
                      angle: animatorState.value * pi,
                      child: Transform.scale(
                        scale: isUnTouched
                            ? (isSubscribed ? 0 : 1)
                            : scaleCurve(animatorState.value),
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 21,
                            height: 21,
                            decoration: BoxDecoration(
                              color: theme.colors.pictureViewerSubscribeBubble,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: theme.colors.pictureViewerCross,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final Picture picture;
  final Tracker? tracker;

  LikeButton({
    Key? key,
    required this.picture,
    this.tracker,
  }) : super(key: key);

  @override
  _LikeButton createState() => _LikeButton();
}

class _LikeButton extends State<LikeButton> {
  late bool isLiked;
  bool isUnTouched = true;
  late AnimatorKey<double> animatorKey;

  @override
  void initState() {
    super.initState();
    this.isLiked =
        globals.cacher.checkLike(widget.picture.id, widget.picture.isLiked);
    this.animatorKey = AnimatorKey();
  }

  likeRequest() {
    getRequest(url: widget.picture.likeUrl).then((data) {
      if (data.status == 200) {
        _pressed();
      } else {
        errorFlushbar("Failed to like")..show(context);
      }
    });
  }

  _pressed() {
    setState(() {
      this.isUnTouched = false;
      this.isLiked = !isLiked;
      globals.cacher.updateLike(widget.picture.id, this.isLiked);
      if (widget.tracker != null) {
        widget.tracker!.updateLike(this.isLiked);
      }
      animatorKey.triggerAnimation();
    });
  }

  doubleTap() {
    if (!this.isLiked) {
      likeRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        likeRequest();
      },
      child: _getSocialAction(
        icon: Animator<double>(
          animatorKey: animatorKey,
          tween: Tween<double>(begin: 0, end: 2),
          repeats: 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          builder: (context, animatorState, child) {
            if (animatorState.value < 1) {
              return Center(
                child: Transform.scale(
                  scale: 1 - animatorState.value,
                  child: getLikeIcon(isUnTouched ? isLiked : !isLiked),
                ),
              );
            } else {
              return Center(
                child: Transform.scale(
                  scale: animatorState.value - 1,
                  child: getLikeIcon(isUnTouched ? !isLiked : isLiked),
                ),
              );
            }
          },
        ),
        title: shortenNum(widget.picture.likesNum -
            (widget.picture.isLiked ? 1 : 0) +
            (this.isLiked ? 1 : 0)),
        isLike: true,
        isLikePressed: isLiked,
      ),
    );
  }
}

class CommentButton extends StatelessWidget {
  Picture picture;
  Function actionsToolbarUpdater;
  AnimatorKey<double> animatorKey = AnimatorKey<double>();

  CommentButton({required this.picture, required this.actionsToolbarUpdater});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animatorKey.triggerAnimation(restart: true);
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return CommentSection(
                picture: picture, actionsToolbarUpdater: actionsToolbarUpdater);
          },
        );
      },
      child: _getSocialAction(
        icon: TapAnimation(
          animatorKey: animatorKey,
          child: getCommentIcon(),
        ),
        title: shortenNum(picture.commentsNum),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  Picture picture;
  Function actionsToolbarUpdater;

  CommentSection({required this.picture, required this.actionsToolbarUpdater});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late Storage commentsStorage;
  late ScrollController scrollController;

  void updateComments() {
    widget.picture.commentsNum += 1;
    widget.actionsToolbarUpdater();
    this.commentsStorage.rebuild().then((value) => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    this.commentsStorage = Storage(
      sourceUrl: "$pictureComments/${widget.picture.id}",
      loadMoreNumber: 15,
      offset: true,
    );
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (!commentsStorage.isLoading &&
          scrollController.position.extentAfter < 100) {
        commentsStorage.addObjects().then((response) {
          setState(() {});
        });
      }
    });
    this.commentsStorage.addObjects().then((value) {
      setState(() {});
    });
  }

  Widget get listView {
    if (commentsStorage.size() > 0) {
      return ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: commentsStorage.size(),
        itemBuilder: (context, index) {
          Comment comment = commentsStorage.getObject(index);
          AnimatorKey<double> animatorKey = AnimatorKey();
          return GestureDetector(
            onLongPress: () {
              var isLoading = false;
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return BottomActionsSheet(
                    bottomActionsListTiles: [
                      constructListTile(
                        "Copy",
                        Icon(Icons.copy_rounded,
                            color: theme.colors.secondaryColor, size: 22),
                        () {
                          if (isLoading) return;
                          isLoading = true;
                          Clipboard.setData(
                              new ClipboardData(text: comment.text));
                          Navigator.pop(context);
                          successFlushbar("Comment copied")..show(context);
                        },
                      ),
                      constructListTile(
                        "Delete",
                        Icon(Icons.delete_outline_rounded,
                            color: theme.colors.attentionColor, size: 27),
                        () {
                          if (isLoading) return;
                          isLoading = true;
                          getRequest(url: comment.deleteUrl).then(
                            (response) async {
                              if (response.status == 200) {
                                await commentsStorage
                                    .rebuild()
                                    .then((value) => setState(() {}));
                                widget.picture.commentsNum =
                                    max(0, widget.picture.commentsNum - 1);
                                widget.actionsToolbarUpdater();
                                Navigator.pop(context);
                                successFlushbar("Comment deleted")
                                  ..show(context);
                              } else {
                                errorFlushbar("Failed to delete comment")
                                  ..show(context);
                                isLoading = false;
                              }
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              color: Colors.white.withOpacity(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            ProfileScreen(
                              profile: comment.profile,
                            ),
                          ),
                        );
                      },
                      child: CustomCircleAvatar(
                          profile: comment.profile, radius: 18),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                createRoute(
                                  ProfileScreen(
                                    profile: comment.profile,
                                  ),
                                ),
                              );
                            },
                            child: Text(comment.profile.screenName,
                                style: theme.texts.pictureViewerCommentAuthor),
                          ),
                          Container(height: 8),
                          RichText(
                            text: TextSpan(
                              style: theme.texts.pictureViewerCommentText,
                              children: [
                                TextSpan(
                                  text: comment.text,
                                ),
                                TextSpan(
                                  text: " " +
                                      shortenTimeDelta(DateTime.now()
                                                  .millisecondsSinceEpoch ~/
                                              1000 -
                                          comment.date),
                                  style: theme.texts.pictureViewerCommentDate,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          getRequest(url: comment.likeUrl).then((value) {
                            animatorKey.triggerAnimation();
                            setState(
                              () {
                                if (comment.isLiked) {
                                  comment.likesNum -= 1;
                                } else {
                                  comment.likesNum += 1;
                                }
                                comment.isLiked = !comment.isLiked;
                              },
                            );
                          });
                        },
                        child: Column(
                          children: [
                            TapAnimation(
                              animatorKey: animatorKey,
                              child: IconTheme(
                                  data: comment.isLiked
                                      ? theme.icons.commentHeartPressed
                                      : theme.icons.commentHeartUnpressed,
                                  child: comment.isLiked
                                      ? Icon(AppIcons.profileHeartFilled)
                                      : Icon(AppIcons.profileHeartPublic)),
                            ),
                            if (comment.likesNum != 0)
                              Text(
                                shortenNum(comment.likesNum),
                                style:
                                    theme.texts.pictureViewerCommentHeartLabel,
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (commentsStorage.isLoading) {
        return Center(
          child: StyledLoadingIndicator(color: theme.colors.secondaryColor),
        );
      } else {
        return Stack(
          children: [
            Center(
              child: Text(
                "No comments yet",
                style: theme.texts.emptyCommentSection,
              ),
            ),
            if (Random().nextInt(100) > 99)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 150,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image(image: AssetImage('assets/images/waiting.png')),
                ),
              )
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: theme.colors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: constraintElevation,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: theme.colors.appBarColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text("${widget.picture.commentsNum} comments",
                              style: theme.texts.pictureViewerCommentUpBar),
                        ),
                      ),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12)),
                            child: IconTheme(
                              data: IconThemeData(
                                color: Colors.black,
                                size: 18,
                              ),
                              child: Icon(Icons.close),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: listView,
                ),
                AddComment(
                  addCommentUrlProvider: () => widget.picture.addCommentUrl,
                  updateComments: updateComments,
                  staticCommentSectionColor: theme.colors.appBarColor,
                  staticCommentSectionTextStyle: theme.texts.yourCommentStatic,
                  dynamicCommentSectionTextStyle: theme.texts.yourComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddComment extends StatefulWidget {
  final Function addCommentUrlProvider;
  final Function? updateComments;
  final Color staticCommentSectionColor;
  final TextStyle staticCommentSectionTextStyle;
  final TextStyle dynamicCommentSectionTextStyle;

  AddComment(
      {required this.addCommentUrlProvider,
      this.updateComments,
      required this.staticCommentSectionColor,
      required this.staticCommentSectionTextStyle,
      required this.dynamicCommentSectionTextStyle});

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final textController = TextEditingController();

  Future<void> sendComment(addCommentUrl) async {
    if (textController.text.trim().length == 0) {
      errorFlushbar("Please, write something")..show(context);
      return;
    }
    Response response = await postRequest(
      url: addCommentUrl,
      body: {"content": textController.text.trim()},
    );
    if (response.status == 200) {
      textController.clear();
      if (widget.updateComments != null) widget.updateComments!();
      Navigator.of(context).pop();
    } else {
      errorFlushbar("Failed to comment")..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: widget.staticCommentSectionColor,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          left: false,
          right: false,
          child: Container(
            alignment: Alignment.center,
            height: ConstraintsHeights.navigationBarHeight,
            child: TextField(
              controller: textController,
              readOnly: true,
              style: widget.dynamicCommentSectionTextStyle,
              decoration: InputDecoration(
                hintStyle: widget.staticCommentSectionTextStyle,
                border: InputBorder.none,
                hintText: "Add comment...",
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
              onTap: () {
                if (!globals.isLogged) {
                  showAuthenticationScreen(context);
                  return;
                }
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: ConstraintsHeights.navigationBarHeight,
                      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () async {
                            await sendComment(widget.addCommentUrlProvider());
                          },
                          controller: textController,
                          autofocus: true,
                          style: theme.texts.yourComment,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add comment...",
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final Picture picture;
  final Tracker? tracker;

  AnimatorKey<double> animatorKey = AnimatorKey<double>();

  ShareButton({required this.picture, this.tracker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animatorKey.triggerAnimation(restart: true);
        getRequest(url: picture.getShareUrl).then((response) {
          if (response.status == 200) {
            Clipboard.setData(
                new ClipboardData(text: response.jsonContent["share_url"]));
            if (tracker != null) {
              tracker!.updateShare();
            }
            successFlushbar("Share link copied")..show(context);
          } else {
            errorFlushbar("Failed to get a link")..show(context);
          }
        });
      },
      child: _getSocialAction(
        icon: TapAnimation(
          animatorKey: animatorKey,
          child: getShareIcon(),
        ),
        title: 'Share',
        isShare: true,
      ),
    );
  }
}

class MoreButton extends StatelessWidget {
  final Picture picture;

  AnimatorKey<double> animatorKey = AnimatorKey<double>();

  MoreButton({required this.picture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animatorKey.triggerAnimation(restart: true);
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return BottomActionsSheet(bottomActionsListTiles: [
              constructListTile(
                "Report content",
                Icon(Icons.outlined_flag_rounded,
                    color: theme.colors.attentionColor, size: 27),
                () {
                  getRequest(url: picture.reportUrl).then((response) {
                    Navigator.pop(context);
                    successFlushbar(
                        "Picture is reported.\nModerators will review it.")
                      ..show(context);
                  });
                },
              ),
            ]);
          },
        );
      },
      child: _getSocialAction(
        icon: TapAnimation(
          animatorKey: animatorKey,
          child: getMoreIcon(),
        ),
        title: 'More',
      ),
    );
  }
}

Widget getLikeIcon(bool pressed) {
  return IconTheme(
    data: pressed
        ? theme.icons.pictureViewerLikePressed
        : theme.icons.pictureViewerLikeUnPressed,
    child: Icon(
      TikTokIcons.heart,
    ),
  );
}

Widget getCommentIcon() {
  return IconTheme(
    data: theme.icons.pictureViewerComment,
    child: Icon(
      TikTokIcons.chat_bubble,
    ),
  );
}

Widget getShareIcon() {
  return IconTheme(
    data: theme.icons.pictureViewerShare,
    child: Icon(
      TikTokIcons.reply,
    ),
  );
}

Widget getMoreIcon() {
  return IconTheme(
    data: theme.icons.pictureViewerMore,
    child: Icon(
      Icons.more_horiz_rounded,
    ),
  );
}

Widget _getSocialAction({
  required String title,
  icon,
  bool isShare = false,
  bool isLike = false,
  bool isLikePressed = true,
}) {
  return Container(
    width: 60.0,
    color: Colors.white.withOpacity(0),
    child: Column(
      children: <Widget>[
        icon,
        Container(
          alignment: Alignment(0.03, 0.0),
          child: Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: Text(
              title,
              style: theme.texts.pictureViewerToolbarLabel,
            ),
          ),
        )
      ],
    ),
  );
}
