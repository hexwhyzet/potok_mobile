import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart';
import 'package:potok/models/functions.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/circle_avatar.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/profile/profile_screen.dart';

class ActionsScreen extends StatefulWidget {
  @override
  _ActionsScreenState createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen>
    with AutomaticKeepAliveClientMixin<ActionsScreen> {
  Storage storage;

  bool get wantKeepAlive => true;

  ScrollController scrollController;

  @override
  void initState() {
    storage = Storage(
      sourceUrl: config.lastActions,
      loadMoreNumber: 15,
      deltaToReload: 5,
      offset: true,
    );
    storage.addObjects().then((value) {
      setState(() {});
    });
    this.scrollController = ScrollController();
    this.scrollController.addListener(() {
      if (storage.hasMore && !storage.isLoading &&
          scrollController.position.extentAfter < 100) {
        storage.addObjects().then((value) => setState(() {}));
      }
    });
  }

  Widget loadingScreen({Widget child}) {
    if (storage.size() == 0 && storage.isLoading == true) {
      return Center(
        child: StyledLoadingIndicator(
          color: theme.colors.secondaryColor,
        ),
      );
    } else {
      return child;
    }
  }

  Widget page() {
    if (storage.size() == 0 && !storage.isLoading) {
      return Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(
          "Subscriptions and Likes will be displayed there.\nThere are none of them yet.",
          style: theme.texts.emptyActionsPage,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () {
          return storage.rebuild().then((value) => setState(() {}));
        },
        child: loadingScreen(
          child: ListView.builder(
            controller: scrollController,
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: storage.size(),
            itemBuilder: (context, position) {
              dynamic action = storage.getObject(position);
              Profile profile = action.profile;
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            ProfileScreen(
                              profile: profile,
                            ),
                          ),
                        );
                      },
                      child: CustomCircleAvatar(profile: profile, radius: 25),
                    ),
                    if (action.type == "like")
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              style: theme.texts.activity,
                              children: [
                                TextSpan(
                                  text: profile.screenName,
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.push(
                                          context,
                                          createRoute(
                                            ProfileScreen(
                                              profile: profile,
                                            ),
                                          ),
                                        ),
                                ),
                                TextSpan(
                                  text: " liked your picture.",
                                  style:
                                  TextStyle(fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: "  " + shortenTimeDelta(
                                    DateTime
                                        .now()
                                        .millisecondsSinceEpoch ~/ 1000 -
                                        action.date,
                                  ),
                                  style: theme.texts.activityTime,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (action.type == "subscription")
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              style: theme.texts.activity,
                              children: [
                                TextSpan(
                                  text: profile.screenName,
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.push(
                                          context,
                                          createRoute(
                                            ProfileScreen(
                                              profile: profile,
                                            ),
                                          ),
                                        ),
                                ),
                                TextSpan(
                                  text: " subscribed to you.",
                                  style:
                                  TextStyle(fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: "  " + shortenTimeDelta(
                                    DateTime
                                        .now()
                                        .millisecondsSinceEpoch ~/ 1000 -
                                        action.date,
                                  ),
                                  style: theme.texts.activityTime,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (action.type == "like")
                      Align(
                        alignment: Alignment.centerRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: StyledFadeInImageNetwork(
                              image: action.picture.lowResUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: Colors.white,
        //     systemNavigationBarColor: Colors.black),
        toolbarHeight: ConstraintsHeights.appBarHeight,
        backgroundColor: theme.colors.appBarColor,
        elevation: constraintElevation,
        centerTitle: true,
        title: Container(
          child: Text(
            "activity",
            style: theme.texts.profileScreenNameYours,
          ),
        ),
      ),
      backgroundColor: theme.colors.backgroundColor,
      body: SafeArea(
        child: page(),
      ),
    );
  }
}
