import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:potok/configs/icons.dart';
import 'package:potok/resources/functions/common.dart';
import 'package:potok/resources/models/profile.dart';
import 'package:potok/resources/models/profile_preview.dart';
import 'package:potok/resources/repositories/loadable_list_repository.dart';
import 'package:potok/resources/repositories/picture_repository.dart';
import 'package:potok/resources/repositories/profile_repository.dart';
import 'package:potok/screens/common/circle_image.dart';
import 'package:potok/screens/common/shimmer.dart';
import 'package:potok/screens/common/styled_fade_in_image_network.dart';
import 'package:potok/screens/common/vertical_gradient_shadow.dart';
import 'package:potok/screens/loadable_list/loadable_list_bloc.dart';
import 'package:potok/screens/loadable_list/loadable_list_event.dart';
import 'package:potok/screens/loadable_list/loadable_list_state.dart';
import 'package:potok/screens/picture/picture_bloc.dart';
import 'package:potok/screens/picture/picture_state.dart';
import 'package:potok/screens/picture/views/picture_screen.dart';
import 'package:potok/screens/profile/profile_bloc.dart';
import 'package:potok/screens/profile/profile_event.dart';
import 'package:potok/screens/profile/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    required this.profileId,
  });

  final int profileId;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: BlocProvider(
        create: (BuildContext context) => ProfileBloc(
            profileRepository: ProfileRepository(context),
            profileId: profileId),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status.isInitial | state.status.isLoading) {
              return ProfileScaffold(
                profileId: this.profileId,
                isProfileLoading: true,
              );
            } else if (state.status.isFailure) {
              return Center(
                child: Container(
                  color: Colors.red,
                  child: Text('Error'),
                ),
              );
            } else if (state.status.isSuccess | state.status.isRefreshing) {
              return ProfileScaffold(
                profileId: this.profileId,
                profilePreview: state.profilePreview,
                profile: state.profile,
                isProfileLoading: false,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ProfileScaffold extends StatelessWidget {
  ProfileScaffold({
    required this.profileId,
    this.profilePreview,
    this.profile,
    this.isProfileLoading = false,
  });

  final int profileId;
  final ProfilePreview? profilePreview;
  final Profile? profile;
  final bool isProfileLoading;

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: this.isProfileLoading
          ? Container(
              padding: EdgeInsets.all(5),
              child: ShimmerLoading(
                isLoading: this.isProfileLoading,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).backgroundColor,
                  ),
                  width: 200,
                  height: 24,
                ),
              ),
            )
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                this.profile!.screenName ?? '',
                style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return ShimmerLoading(
      isLoading: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              ShimmerLoading(
                isLoading: true,
                child: Container(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              if (!this.isProfileLoading)
                StyledFadeInImageNetwork(
                  image: this.profilePreview!.avatar.sizes.medium.url,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBar(
      {required double height, EdgeInsets padding = EdgeInsets.zero}) {
    return Padding(
      padding: padding,
      child: ShimmerLoading(
        isLoading: this.isProfileLoading,
        child: Center(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRightSection(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: !this.isProfileLoading
              ? [
                  if (this.profilePreview!.isAvailable) _buildStats(context),
                  if (this.profilePreview!.isAvailable) _buildButtons(context),
                  if (!this.profilePreview!.isAvailable)
                    _buildUnavailableProfileTextBlock(context)
                ]
              : [
                  _buildLoadingBar(
                      height: 24, padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: _buildLoadingBar(
                        height: 24, padding: EdgeInsets.only(left: 10)),
                  ),
                  _buildLoadingBar(
                      height: 24, padding: EdgeInsets.only(left: 10)),
                ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(context),
        ..._buildAttachmentsButton(context),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSingleStat(
          context,
          AppLocalizations.of(context)!.followers,
          this.profile!.followersNum,
        ),
        _buildSingleStat(
          context,
          AppLocalizations.of(context)!.following,
          this.profile!.followingNum,
        ),
        _buildSingleStat(
          context,
          AppLocalizations.of(context)!.likes,
          this.profile!.likesNum,
        ),
      ],
    );
  }

  Widget _buildSingleStat(BuildContext context, String label, int value) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            shortenNum(value),
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).unselectedWidgetColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildEditProfileButton() {
  //   return TextButton(
  //     onPressed: () => {
  //       Navigator.push(
  //         context,
  //         createRoute(
  //           ProfileSettingsPage(
  //             profile: widget.profile,
  //           ),
  //         ),
  //       ).whenComplete(() {
  //         if (widget.reloadProfile != null) {
  //           widget.reloadProfile!();
  //         }
  //       })
  //     },
  //     style: TextButton.styleFrom(
  //       // splashFactory: NoSplash.splashFactory,
  //       padding: EdgeInsets.all(0),
  //       minimumSize: Size(120, 35),
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide(
  //           color: Colors.grey.shade300,
  //           width: 1.5,
  //           style: BorderStyle.solid,
  //         ),
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //     ),
  //     child: Text(
  //       'Edit profile',
  //       style: theme.texts.editProfileButton,
  //     ),
  //   );
  // }

  Widget _buildButton(BuildContext context) {
    String getButtonText() {
      switch (this.profile!.subscriptionStatus) {
        case -1:
          return AppLocalizations.of(context)!.editProfile;
        case 0:
          return AppLocalizations.of(context)!.follow;
        case 1:
          return AppLocalizations.of(context)!.cancelRequest;
        case 2:
          return AppLocalizations.of(context)!.unfollow;
      }
      return 'Error';
    }

    return Row(
      children: [
        TextButton(
          onPressed: () {
            BlocProvider.of<ProfileBloc>(context)
                .add(SubscriptionButtonPressed());
          },
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.all(0),
            minimumSize: Size(120, 35),
            backgroundColor: this.profile!.subscriptionStatus == 0
                ? Theme.of(context).accentColor
                : Theme.of(context).unselectedWidgetColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: this.profile!.subscriptionStatus == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).unselectedWidgetColor,
                width: 1.5,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            getButtonText(),
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleAttachmentButton(BuildContext context, IconData iconData,
      Color textColor, Color backColor, String url) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: TextButton(
        onPressed: () async {
          openUniversalUrl(url);
        },
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(35, 35),
          backgroundColor: backColor,
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Icon(
          iconData,
          color: textColor,
          // style: Theme.of(context).textTheme.headline5!.copyWith(
          //   color: textColor,
          // ),
        ),
      ),
    );
  }

  Widget _buildVkAttachmentButton(BuildContext context, String url) {
    return _buildSingleAttachmentButton(
      context,
      AppIcons.vk,
      Colors.white,
      Theme.of(context).accentColor,
      url,
    );
  }

  Widget _buildRedditAttachmentButton(BuildContext context, String url) {
    return _buildSingleAttachmentButton(
      context,
      AppIcons.reddit,
      Colors.white,
      Colors.deepOrange,
      url,
    );
  }

  Widget _buildWebAttachmentButton(BuildContext context, String url) {
    return _buildSingleAttachmentButton(
      context,
      Icons.public,
      Colors.white,
      Colors.grey.shade600,
      url,
    );
  }

  List<Widget> _buildAttachmentsButton(BuildContext context) {
    var answerList = <Widget>[];
    for (final attachment in this.profile!.attachments) {
      switch (attachment.tag) {
        case 'vk':
          answerList.add(_buildVkAttachmentButton(context, attachment.url));
          break;
        case 'reddit':
          answerList.add(_buildRedditAttachmentButton(context, attachment.url));
          break;
        case 'web':
          answerList.add(_buildWebAttachmentButton(context, attachment.url));
          break;
      }
    }
    return answerList;
  }

  // PreferredSizeWidget _buildProfileAppBar(BuildContext context) {
  //   final bool canPop = ModalRoute
  //       .of(context)
  //       ?.canPop ?? false;
  //   if (canPop) {
  //     return AppBar(
  //       toolbarHeight: ConstraintsHeights.appBarHeight,
  //       leading: BackArrowButton(),
  //       centerTitle: true,
  //       title: Text(
  //         widget.profile.screenName,
  //         style: theme.texts.profileScreenName,
  //       ),
  //       backgroundColor: theme.colors.appBarColor,
  //       elevation: constraintElevation,
  //       actions: [
  //         IconButton(
  //           tooltip: 'More',
  //           icon: IconTheme(
  //             data: theme.icons.morePeriods,
  //             child: Icon(Icons.more_horiz_rounded),
  //           ),
  //           onPressed: () {
  //             showModalBottomSheet(
  //               backgroundColor: Colors.transparent,
  //               context: context,
  //               builder: (BuildContext context) {
  //                 return BottomActionsSheet(
  //                   bottomActionsListTiles: [
  //                     constructListTile(
  //                       widget.profile.isUserBlockedByYou ? "Unblock" : "Block",
  //                       Icon(
  //                           widget.profile.isUserBlockedByYou
  //                               ? Icons.remove_red_eye_outlined
  //                               : Icons.error_outline_rounded,
  //                           color: widget.profile.isUserBlockedByYou
  //                               ? theme.colors.secondaryColor
  //                               : theme.colors.attentionColor,
  //                           size: 27),
  //                           () {
  //                         getRequest(url: widget.profile.blockUrl)
  //                             .then((response) {
  //                           getRequest(url: widget.profile.reloadUrl)
  //                               .then((response) {
  //                             widget.profile =
  //                                 objectFromJson(response.jsonContent);
  //                             setState(() {});
  //                             Navigator.pop(context);
  //                             globals.cacher
  //                                 .updateSub(widget.profile.id, false);
  //                             if (widget.profile.isUserBlockedByYou) {
  //                               successFlushbar("Profile blocked")
  //                                 ..show(context);
  //                             } else {
  //                               successFlushbar("Profile unblocked")
  //                                 ..show(context);
  //                             }
  //                           });
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ],
  //     );
  //   } else {
  //     return AppBar(
  //       centerTitle: true,
  //       toolbarHeight: ConstraintsHeights.appBarHeight,
  //       title: Container(
  //         child: Text(
  //           widget.profile.screenName,
  //           style: theme.texts.profileScreenNameYours,
  //         ),
  //       ),
  //       backgroundColor: theme.colors.appBarColor,
  //       elevation: constraintElevation,
  //     );
  //   }
  // }

  Widget _buildUnavailableProfileTextBlock(BuildContext context) {
    if (this.profilePreview!.isPrivate) {
      return Text(AppLocalizations.of(context)!.thisAccountIsPrivate);
    } else if (this.profilePreview!.blockStatus != 0) {
      final blockStatus = profilePreview!.blockStatus;
      if ((blockStatus == 1) | (blockStatus == 3)) {
        return Text(
          AppLocalizations.of(context)!.youBlockedTheUser,
        );
      } else {
        return Text(AppLocalizations.of(context)!.theUserBlockedYou);
      }
    } else {
      return Text(AppLocalizations.of(context)!.youDontHaveAccessToThisProfile);
    }
  }

  Widget _buildName(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.centerLeft,
      child: this.isProfileLoading
          ? _buildLoadingBar(height: 22)
          : Text(
              this.profile!.name ?? '',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.centerLeft,
      child: this.isProfileLoading
          ? _buildLoadingBar(height: 22)
          : Text(
              this.profile!.description ?? '',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
    );
  }

  Widget _buildAvatarAndTopRightSection(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomCircleAvatar(
          radius: 60,
          imageUrl: this.isProfileLoading
              ? ''
              : this.profilePreview!.avatar.sizes.medium.url,
          isLoading: this.isProfileLoading,
        ),
        _buildTopRightSection(context),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      width: double.infinity,
      child: Column(
        children: [
          _buildAvatarAndTopRightSection(context),
          _buildName(context),
          // _buildDescription(context),
        ],
      ),
    );
  }

  Widget _buildTabControllerIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Icon(
        iconData,
        size: 34,
      ),
    );
  }

  Widget _buildProfileFooter(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(
            tabs: [
              _buildTabControllerIcon(AppIcons.profileGrid),
              _buildTabControllerIcon(
                this.isProfileLoading
                    ? AppIcons.profileHeartPublic
                    : this.profile!.isLikedPicturesPageAvailable
                        ? AppIcons.profileHeartPublic
                        : AppIcons.profileHeartPrivate,
              ),
            ],
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            labelColor: Theme.of(context).selectedRowColor,
            indicatorColor: Theme.of(context).selectedRowColor,
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                children: [
                  _buildPicturesGrid(context),
                  _buildPicturesGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicturesGrid(BuildContext context) {
    if (!this.isProfileLoading && !this.profile!.isAvailable) {
      String textLine1 = '';
      String textLine2 = '';
      textLine1 = 'You can\'t see user\'s pictures';
      if (this.profile!.blockStatus != 0) {
        if ((this.profile!.blockStatus == 1) |
            (this.profile!.blockStatus == 3)) {
          textLine2 = 'Unblock the user to it\'s pictures';
        } else {
          textLine2 = 'The user blocked you';
        }
      }

      return _buildGridGapDescription(
        textLine1: textLine1,
        textLine2: textLine2,
      );
    } else {
      return PictureGrid(
        loadableListRepository: ProfilePictureBlocsLoadableListRepository(
          context,
          profileId: this.profileId,
          pictureRepository: PictureRepository(context),
        ),
        isProfileLoading: this.isProfileLoading,
      );
    }
  }

  Widget _buildGridGapDescription(
      {String textLine1 = '', String textLine2 = ''}) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(textLine1),
          Container(height: 10),
          Text(textLine2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: _buildProfileHeader(context),
            ),
          ];
        },
        body: _buildProfileFooter(context),
      ),
    );
  }
}

class PictureGrid extends StatelessWidget {
  PictureGrid(
      {required this.loadableListRepository, this.isProfileLoading = false});

  final ProfilePictureBlocsLoadableListRepository loadableListRepository;

  final bool isProfileLoading;

  Widget pictureBlocPreview(PictureBloc pictureBloc) {
    return BlocBuilder<PictureBloc, PictureState>(
      bloc: pictureBloc,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              StyledFadeInImageNetwork(
                fit: BoxFit.cover,
                image: state.picture!.sizes.small.url,
              ),
              VerticalGradientShadow(
                height: 30,
                alignment: Alignment.bottomCenter,
                upperColor: Colors.transparent,
                lowerColor: Color.fromRGBO(40, 40, 40, 0.4),
              ),
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            size: 16,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.remove_red_eye),
                        ),
                        Container(
                          width: 4,
                        ),
                        Text(
                          shortenNum(state.picture!.viewsNum),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoadableListBloc<PictureBloc>>(
      create: (BuildContext context) => LoadableListBloc<PictureBloc>(
        repository: loadableListRepository,
      ),
      child: BlocBuilder<LoadableListBloc<PictureBloc>,
          LoadableListState<PictureBloc>>(
        builder: (context, state) {
          if (state.status.isFinished && state.list.isEmpty) {
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    child: Image(
                      image: AssetImage('assets/images/tears.png'),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.noPicturesYet,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            );
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!state.status.isLoading &&
                    !state.status.isFinished &&
                    (scrollInfo.metrics.pixels + 600 >
                        scrollInfo.metrics.maxScrollExtent)) {
                  BlocProvider.of<LoadableListBloc<PictureBloc>>(context)
                      .add(LoadMore(state.lastPageLoaded + 1));
                }
                return true;
              },
              child: GridView.builder(
                itemCount: state.list.length +
                    ((this.isProfileLoading | !state.status.isFinished)
                        ? (12 + (3 - state.list.length % 3))
                        : 0),
                // 6 more empty pictures during loading
                shrinkWrap: true,
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          margin: EdgeInsets.all(1),
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      if (index < state.list.length)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<
                                        LoadableListBloc<PictureBloc>>(context),
                                    child:
                                        PicturePageViewWithPreCreatedLoadableList(
                                      initialPage: index,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          onLongPress: () {
                            // if (!picture.canBeDeleted) return;
                            // var isLoading = false;
                            // showModalBottomSheet(
                            //   backgroundColor: Colors.transparent,
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return BottomActionsSheet(bottomActionsListTiles: [
                            //       constructListTile(
                            //         "Delete picture",
                            //         Icon(Icons.delete_outline_rounded,
                            //             color: theme.colors.attentionColor, size: 27),
                            //             () {
                            //           if (isLoading) return;
                            //           isLoading = true;
                            //           getRequest(url: storage
                            //               .getObject(index)
                            //               .deleteUrl)
                            //               .then(
                            //                 (response) async {
                            //               if (response.status == 200) {
                            //                 await storage
                            //                     .rebuild()
                            //                     .then((value) => setState(() {}));
                            //                 Navigator.pop(context);
                            //                 successFlushbar("Picture deleted")
                            //                   ..show(context);
                            //               } else {
                            //                 errorFlushbar("Failed to delete picture")
                            //                   ..show(context);
                            //                 isLoading = false;
                            //               }
                            //             },
                            //           );
                            //         },
                            //       ),
                            //     ]);
                            //   },
                            // );
                          },
                          child:
                              pictureBlocPreview(state.list.elementAt(index)),
                        ),
                    ],
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
