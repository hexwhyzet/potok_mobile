import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/models/objects.dart';
import 'package:potok/models/picture.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/actions_bottom_sheet.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/flushbar.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/home/picture_viewer.dart';
import 'package:potok/widgets/settings/settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  reloadProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Response>(
        future: getRequest(config.myProfileUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProfileScreen(
              profile: Profile.fromJson(snapshot.data.jsonContent),
              reloadProfile: reloadProfile,
            );
          } else {
            return Align(
              child: SizedBox(
                width: 30,
                height: 30,
                child:
                    StyledLoadingIndicator(color: theme.colors.secondaryColor),
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  Profile profile;
  Function reloadProfile;

  ProfileScreen({@required this.profile, this.reloadProfile});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController;
  GlobalKey<_PicturesGridState> globalKey1 = GlobalKey();
  GlobalKey<_PicturesGridState> globalKey2 = GlobalKey();
  bool isSubscribed;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController(
      initialScrollOffset: 0,
      keepScrollOffset: true,
    );
    this._scrollController.addListener(_scrollListener);
    this.isSubscribed =
        cacher.checkSub(widget.profile.id, widget.profile.isSubscribed);
    this._tabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
  }

  _scrollListener() {
    if (this._tabController.index == 0 && globalKey1.currentState != null) {
      if (globalKey1.currentState.storage.hasMore &&
          !globalKey1.currentState.storage.isLoading &&
          _scrollController.position.extentAfter < 300) {
        globalKey1.currentState.storage
            .addObjects()
            .then((value) => globalKey1.currentState.setState(() {}));
      }
    } else if (globalKey2.currentState != null) {
      if (globalKey2.currentState.storage.hasMore &&
          !globalKey2.currentState.storage.isLoading &&
          _scrollController.position.extentAfter < 300) {
        globalKey2.currentState.storage
            .addObjects()
            .then((value) => globalKey2.currentState.setState(() {}));
      }
    }
  }

  Widget getStats(label, value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: theme.texts.profileStatsNumber,
        ),
        Container(
          height: 2,
        ),
        Text(
          label,
          style: theme.texts.profileStatsLabel,
        )
      ],
    );
  }

  Widget getEditProfileButton() {
    return TextButton(
      onPressed: () => {
        Navigator.push(
          context,
          createRoute(
            ProfileSettingsPage(
              profile: widget.profile,
            ),
          ),
        ).whenComplete(() {
          widget.reloadProfile();
        })
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.all(0),
        minimumSize: Size(120, 35),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        'Edit profile',
        style: theme.texts.editProfileButton,
      ),
    );
  }

  Widget getButton() {
    return TextButton(
      onPressed: () => {
        getRequest(widget.profile.subscribeUrl).then((data) {
          if (data.status == "ok") {
            setState(() {
              this.isSubscribed =
                  cacher.updateSub(widget.profile.id, !this.isSubscribed);
            });
          } else {
            errorFlushbar("Failed to subscribe")..show(context);
          }
        })
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.all(0),
        minimumSize: Size(120, 35),
        backgroundColor: this.isSubscribed
            ? Colors.transparent
            : theme.colors.secondaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: this.isSubscribed
                ? theme.colors.profileButtonOutline
                : theme.colors.secondaryColor,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        this.isSubscribed ? 'Subscribed' : 'Follow',
        style: this.isSubscribed
            ? theme.texts.profileButtonSubscribed
            : theme.texts.profileButtonUnSubscribed,
      ),
    );
  }

  Widget getBlockText() {
    if (widget.profile.isUserBlockedByYou) {
      return Text("You blocked the user", style: theme.texts.profileBlockText);
    } else {
      return Text("The user blocked you");
    }
  }

  Widget getProfile() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: theme.colors.profileAvatarOutline,
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colors.backgroundColor,
                    borderRadius: BorderRadius.circular(58),
                  ),
                  padding: EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(57),
                    child: Container(
                      width: 114,
                      height: 114,
                      child: StyledFadeInImageNetwork(
                        image: widget.profile.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          getStats(
                            "Following",
                            widget.profile.subsNum.toString(),
                          ),
                          getStats(
                            "Followers",
                            (widget.profile.followersNum -
                                    (widget.profile.isSubscribed ? 1 : 0) +
                                    (cacher.checkSub(widget.profile.id,
                                            widget.profile.isSubscribed)
                                        ? 1
                                        : 0))
                                .toString(),
                          ),
                          getStats(
                            "Likes",
                            widget.profile.likesNum.toString(),
                          ),
                        ],
                      ),
                      if (!widget.profile.isYours &&
                          widget.profile.isProfileAvailable)
                        getButton(),
                      if (widget.profile.isUserBlockedByYou ||
                          widget.profile.areYouBlockedByUser)
                        getBlockText(),
                      if (widget.profile.isYours) getEditProfileButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(7, 20, 7, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.profile.name,
              style: theme.texts.profileName,
            ),
          ),
          if (widget.profile.description != null)
            Container(
              padding: EdgeInsets.fromLTRB(7, 5, 7, 10),
              alignment: Alignment.center,
              child: Text(
                widget.profile.description,
                style: theme.texts.profileDescription,
              ),
            ),
        ],
      ),
    );
  }

  Widget profileAppBar() {
    final bool canPop = ModalRoute.of(context)?.canPop ?? false;
    if (canPop) {
      return AppBar(
        toolbarHeight: ConstraintsHeights.appBarHeight,
        leading: BackArrowButton(),
        centerTitle: true,
        title: Text(
          widget.profile.screenName,
          style: theme.texts.profileScreenName,
        ),
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        actions: [
          IconButton(
            tooltip: 'More',
            icon: IconTheme(
              data: theme.icons.morePeriods,
              child: Icon(Icons.more_horiz_rounded),
            ),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return BottomActionsSheet(
                    bottomActionsListTiles: [
                      constructListTile(
                        widget.profile.isUserBlockedByYou ? "Unblock" : "Block",
                        Icon(
                            widget.profile.isUserBlockedByYou
                                ? Icons.remove_red_eye_outlined
                                : Icons.error_outline_rounded,
                            color: widget.profile.isUserBlockedByYou
                                ? theme.colors.secondaryColor
                                : theme.colors.attentionColor,
                            size: 27),
                        () {
                          getRequest(widget.profile.blockUrl).then((response) {
                            getRequest(widget.profile.reloadUrl)
                                .then((response) {
                              widget.profile =
                                  objectFromJson(response.jsonContent);
                              setState(() {});
                              Navigator.pop(context);
                              globals.cacher
                                  .updateSub(widget.profile.id, false);
                              if (widget.profile.isUserBlockedByYou) {
                                successFlushbar("Profile blocked")
                                  ..show(context);
                              } else {
                                successFlushbar("Profile unblocked")
                                  ..show(context);
                              }
                            });
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      );
    } else {
      return AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        toolbarHeight: ConstraintsHeights.appBarHeight,
        title: Container(
          child: Text(
            widget.profile.screenName,
            style: theme.texts.profileScreenNameYours,
          ),
        ),
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
      );
    }
  }

  Widget gapDescription(int tabNum) {
    if (widget.profile.isUserBlockedByYou) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Text("The User is blocked by you",
                style: theme.texts.profilePrivacyMessageHeader),
            Container(height: 10),
            Text("To see his pictures unblock it",
                style: theme.texts.profilePrivacyMessageText),
          ],
        ),
      );
    } else if (widget.profile.areYouBlockedByUser) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Text("The User blocked by you",
                style: theme.texts.profilePrivacyMessageHeader),
            Container(height: 10),
            Text("Sorry, you can't see his pictures",
                style: theme.texts.profilePrivacyMessageText),
          ],
        ),
      );
    } else if (!widget.profile.isProfileAvailable && !widget.profile.isPublic) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Text("This account is private",
                style: theme.texts.profilePrivacyMessageHeader),
            Container(height: 10),
            Text("Send request in order to see his pictures",
                style: theme.texts.profilePrivacyMessageText),
          ],
        ),
      );
    } else if (!widget.profile.areLikedPicturesAvailable) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Text("The User closed access to its liked pictures",
                style: theme.texts.profilePrivacyMessageHeader),
            Container(height: 10),
            Text("User's liked pictures are hidden",
                style: theme.texts.profilePrivacyMessageText),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            Text("Sorry some error occured",
                style: theme.texts.profilePrivacyMessageHeader),
          ],
        ),
      );
    }
  }

  Widget get picturesGrid {
    if (widget.profile.isProfileAvailable) {
      return PicturesGrid(
        key: globalKey1,
        baseUrl: config.profilePicturesUrl,
        profileId: widget.profile.id,
        profile: widget.profile,
      );
    } else {
      return gapDescription(0);
    }
  }

  Widget get likedPicturesGrid {
    if (widget.profile.areLikedPicturesAvailable) {
      return PicturesGrid(
        key: globalKey2,
        baseUrl: config.likedPicturesUrl,
        profileId: widget.profile.id,
        profile: widget.profile,
      );
    } else {
      return gapDescription(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.isSubscribed =
        cacher.checkSub(widget.profile.id, widget.profile.isSubscribed);
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colors.appBarColor,
      appBar: profileAppBar(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: getProfile(),
            ),
          ];
        },
        body: Column(
          children: [
            TabBar(
              controller: this._tabController,
              tabs: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    AppIcons.profileGrid,
                    size: theme.icons.profileTabBar.size,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    widget.profile.areLikedPicturesAvailable
                        ? AppIcons.profileHeartPublic
                        : AppIcons.profileHeartPrivate,
                    size: theme.icons.profileTabBar.size,
                  ),
                ),
              ],
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: theme.colors.profileTabBarIndicator,
            ),
            Expanded(
              child: Container(
                color: theme.colors.backgroundColor,
                child: TabBarView(
                  controller: this._tabController,
                  children: [
                    picturesGrid,
                    likedPicturesGrid,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PicturesGrid extends StatefulWidget {
  final String baseUrl;
  final int profileId;
  final Profile profile;

  PicturesGrid({Key key, this.baseUrl, this.profileId, this.profile})
      : super(key: key);

  @override
  _PicturesGridState createState() => _PicturesGridState();
}

class _PicturesGridState extends State<PicturesGrid>
    with AutomaticKeepAliveClientMixin {
  Storage storage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    storage = Storage(
      loadMoreNumber: 15,
      deltaToReload: 6,
      lastPosition: 0,
      offset: true,
      sourceUrl: "${widget.baseUrl}/${widget.profileId}",
    );
    storage.addObjects().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    if (storage.isEmpty()) {
      if (storage.isLoading) {
        return Container(
          color: theme.colors.backgroundColor,
          child: Align(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:
                    StyledLoadingIndicator(color: theme.colors.secondaryColor),
              ),
            ),
            alignment: Alignment.center,
          ),
        );
      }
    } else {
      return GridView.builder(
        itemCount: storage.size(),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          if (index == storage.size()) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:
                    StyledLoadingIndicator(color: theme.colors.secondaryColor),
              ),
            );
          }
          final Picture picture = storage.getObject(index);
          return GestureDetector(
            onTap: () {
              storage.lastPosition = index;
              Navigator.push(
                context,
                createRoute(
                  PictureViewerScreen(
                    storage: PictureViewerStorage.fromStorage(storage),
                    showProfileAvatar: false,
                  ),
                ),
              ).then((value) => setState(() {}));
            },
            onLongPress: () {
              if (!picture.canBeDeleted) return;
              var isLoading = false;
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return BottomActionsSheet(bottomActionsListTiles: [
                    constructListTile(
                      "Delete picture",
                      Icon(Icons.delete_outline_rounded,
                          color: theme.colors.attentionColor, size: 27),
                      () {
                        if (isLoading) return;
                        isLoading = true;
                        getRequest(storage.getObject(index).deleteUrl).then(
                          (response) async {
                            if (response.status == "ok") {
                              await storage
                                  .rebuild()
                                  .then((value) => setState(() {}));
                              Navigator.pop(context);
                              successFlushbar("Picture deleted")..show(context);
                            } else {
                              errorFlushbar("Failed to delete picture")
                                ..show(context);
                              isLoading = false;
                            }
                          },
                        );
                      },
                    ),
                  ]);
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(1),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: theme.colors.profileEmptyPicture,
                  ),
                  StyledFadeInImageNetwork(
                    fit: BoxFit.cover,
                    image: picture.lowResUrl,
                  ),
                  VerticalGradientShadow(
                    height: 30,
                    alignment: Alignment.bottomCenter,
                    upperColor: Colors.transparent,
                    lowerColor: Color.fromRGBO(40, 40, 40, 0.4),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            size: 17,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.remove_red_eye),
                        ),
                        Container(
                          height: 0,
                          width: 4,
                        ),
                        Text(
                          picture.viewsNum.toString(),
                          style: theme.texts.profilePictureViews,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return Container(); // Do not delete - solution for empty profile
  }
}
