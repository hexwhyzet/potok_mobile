import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/configs/icons.dart';
import 'package:potok/configs/theme_data.dart';
import 'package:potok/old/widgets/common/animations.dart';
import 'package:potok/resources/functions/common.dart';
import 'package:potok/resources/models/picture.dart';
import 'package:potok/resources/repositories/comment_repository.dart';
import 'package:potok/resources/repositories/loadable_list_repository.dart';
import 'package:potok/resources/repositories/picture_repository.dart';
import 'package:potok/screens/comment/views/comment_screen.dart';
import 'package:potok/screens/common/back_arrow_button.dart';
import 'package:potok/screens/common/circle_image.dart';
import 'package:potok/screens/common/interface_visibility_cubit.dart';
import 'package:potok/screens/common/shimmer.dart';
import 'package:potok/screens/common/snackbar.dart';
import 'package:potok/screens/common/splash_screen.dart';
import 'package:potok/screens/common/vertical_gradient_shadow.dart';
import 'package:potok/screens/loadable_list/loadable_list_bloc.dart';
import 'package:potok/screens/loadable_list/loadable_list_event.dart';
import 'package:potok/screens/loadable_list/loadable_list_state.dart';
import 'package:potok/screens/picture/picture_bloc.dart';
import 'package:potok/screens/picture/picture_event.dart';
import 'package:potok/screens/picture/picture_state.dart';
import 'package:potok/widgets/home/custom_scroll_physics.dart';
import 'package:preload_page_view/preload_page_view.dart';

const int LOAD_MORE_THRESHOLD = 5;

class PicturePageViewWithPreCreatedLoadableList extends StatelessWidget {
  PicturePageViewWithPreCreatedLoadableList({
    this.initialPage = 0,
  });

  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return PicturesPageView(initialPage: this.initialPage);
  }
}

class PicturePageViewWithoutPreCreatedLoadableList extends StatelessWidget {
  final LoadableListRepository<PictureBloc> repository;

  PicturePageViewWithoutPreCreatedLoadableList({
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          LoadableListBloc<PictureBloc>(repository: this.repository),
      child: PicturesPageView(),
    );
  }
}

class PicturesPageView extends StatelessWidget {
  PicturesPageView({
    this.initialPage = 0,
  });

  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadableListBloc<PictureBloc>,
        LoadableListState<PictureBloc>>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            leading: InterfaceVisibilityContent(
              child: BackArrowButton(),
            ),
          ),
          body: PreloadPageView.builder(
            controller: PreloadPageController(
              initialPage: initialPage,
            ),
            physics: CustomPageViewScrollPhysics(),
            scrollDirection: Axis.vertical,
            preloadPagesCount: 4,
            itemCount: state.list.length,
            onPageChanged: (index) {
              if (state.list.length - index - 1 <= LOAD_MORE_THRESHOLD) {
                BlocProvider.of<LoadableListBloc<PictureBloc>>(context)
                    .add(LoadMore(state.lastPageLoaded + 1));
              }
            },
            itemBuilder: (context, index) {
              return BlocProvider.value(
                value: state.list.elementAt(index),
                child: PictureBlocView(),
              );
            },
          ),
        );
      },
    );
  }
}

class PictureView extends StatelessWidget {
  PictureView({
    required this.pictureId,
    this.preloadedPicture,
  });

  final int pictureId;
  final Picture? preloadedPicture;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PictureBloc>(
      create: (BuildContext context) => PictureBloc(
        pictureId: this.pictureId,
        pictureRepository: PictureRepository(context),
        preloadedPicture: preloadedPicture,
      ),
      child: PictureBlocView(),
    );
  }
}

class PictureBlocView extends StatelessWidget {
  final defaultToolbarIconSize = 32.0;
  final defaultToolbarIconColor = Colors.grey[200];
  final defaultToolbarTextColor = Colors.grey[100];

  Widget _buildPictureContainer(BuildContext context, PictureState state) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: SplashScreen(
              color: Colors.white,
            ),
          ),
          state.status.isSuccess
              ? Center(
                  child: StyledFadeInImageNetwork(
                    fit: BoxFit.contain,
                    image: state.picture!.sizes.huge.url,
                  ),
                )
              : Container(),
          _buildUpperShadow(context),
          _buildLowerShadow(context),
          _buildActionsToolbar(context, state),
        ],
      ),
    );
  }

  Widget _buildActionsToolbar(BuildContext context, PictureState state) {
    return Container(
      // padding: EdgeInsets.only(bottom: this.widget.bottomPadding),
      child: Shimmer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 10),
              child: GestureDetector(
                onDoubleTap: () {
                  // log("double tap");
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildPictureDescription(context, state),
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
                        _buildProfilePictureButton(context, state),
                        _buildLikeButton(context, state),
                        _buildCommentButton(context, state),
                        _buildShareButton(context, state),
                        _buildMoreButton(context, state),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureButton(BuildContext context, PictureState state) {
    late AnimatorKey<double> animatorKey = AnimatorKey<double>(
      initialValue:
          state.picture!.profilePreview.subscriptionStatus == 0 ? 0 : 1,
    );

    double scaleCurve(double value) {
      if (value > 0.85) {
        return 1 + (1 - value) * 1.5;
      } else if (value > 0.7) {
        return 1 + (value - 0.7) * 1.5;
      } else {
        return value / 0.7;
      }
    }

    var isUnTouched = false;
    var isSubscribed = false;

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
                child: CustomCircleAvatar(
                  radius: 22.5,
                  imageUrl: state.status.isLoading
                      ? ''
                      : state.picture!.profilePreview.avatar.sizes.tiny.url,
                  isLoading: state.status.isLoading,
                ),
              ),
            ),
            onTap: () {},
          ),
          // if (state.status.isSuccess && !state.picture!.profilePreview.isYours)
          //   GestureDetector(
          //     onTap: () {},
          //     child: Animator<double>(
          //       resetAnimationOnRebuild: false,
          //       animatorKey: animatorKey,
          //       tween: Tween<double>(begin: 1, end: 0),
          //       repeats: 1,
          //       duration: Duration(milliseconds: 200),
          //       curve: Curves.linear,
          //       builder: (context, animatorState, child) {
          //         return Container(
          //           margin: EdgeInsets.only(top: 40),
          //           child: Transform.rotate(
          //             angle: animatorState.value * pi,
          //             child: Transform.scale(
          //               scale: isUnTouched
          //                   ? (isSubscribed ? 0 : 1)
          //                   : scaleCurve(animatorState.value),
          //               child: Container(
          //                 alignment: Alignment.center,
          //                 child: Container(
          //                   width: 21,
          //                   height: 21,
          //                   decoration: BoxDecoration(
          //                     color: Theme.of(context).accentColor,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: Icon(
          //                     Icons.add_rounded,
          //                     size: 18,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildPictureDescription(BuildContext context, PictureState state) {
    var textColor = Colors.grey[400];
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   alignment: Alignment.bottomLeft,
          //   child: Text(
          //     "@${state.picture!.profilePreview.screenName}",
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline4!
          //         .copyWith(color: textColor),
          //   ),
          // ),
          if (state.picture!.linkUrl != null)
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.grey.withOpacity(0.2),
                ),
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    "Link",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: textColor),
                  ),
                ),
              ),
              onTap: () async {
                openUniversalUrl(state.picture!.linkUrl!);
              },
            ),
          // ConstrainedBox(
          //   constraints: BoxConstraints(),
          //   child: Container(
          //     child: Text(
          //         "Lorem ipsum dolor Ut enim ad minim veniam, quis nostrud exer",
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline5!
          //             .copyWith(color: textColor)),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, PictureState state) {
    return _buildActionToolbarButton(
      context,
      Icon(
        TikTokIcons.heart,
        size: defaultToolbarIconSize,
        color: state.picture!.isLiked ? RED : defaultToolbarIconColor,
      ),
      shortenNum(state.picture!.likesNum),
      (context) {
        BlocProvider.of<PictureBloc>(context)
            .add(UpdateLikePicture(!state.picture!.isLiked));
      },
    );
  }

  Widget _buildCommentButton(BuildContext context, PictureState state) {
    return _buildActionToolbarButton(
      context,
      Icon(
        TikTokIcons.chat_bubble,
        size: defaultToolbarIconSize,
        color: defaultToolbarIconColor,
      ),
      shortenNum(state.picture!.commentsNum),
      (context) {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return CommentPageViewWithoutPreCreatedLoadableList(
              repository: PictureCommentsBlocsLoadableListRepository(
                context,
                pictureId: state.picture!.id,
                commentRepository: CommentRepository(context),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShareButton(BuildContext context, PictureState state) {
    return _buildActionToolbarButton(
      context,
      Icon(
        TikTokIcons.reply,
        size: defaultToolbarIconSize - 11,
        color: defaultToolbarIconColor,
      ),
      shortenNum(state.picture!.sharesNum),
      (context) {
        BlocProvider.of<PictureBloc>(context).add(SharePicture());
      },
    );
  }

  Widget _buildMoreButton(BuildContext context, PictureState state) {
    return _buildActionToolbarButton(
      context,
      Icon(
        AppIcons.more,
        size: defaultToolbarIconSize,
        color: defaultToolbarIconColor,
      ),
      "",
      (context) {},
    );
  }

  Widget _buildActionToolbarButton(
    BuildContext context,
    Widget icon,
    String title,
    Function(BuildContext context) onTapWithContext,
  ) {
    return GestureDetector(
      onTap: () {
        onTapWithContext(context);
      },
      child: Container(
        width: 60.0,
        color: Colors.white.withOpacity(0),
        child: Column(
          children: <Widget>[
            icon,
            Container(
              alignment: Alignment(0.06, 0.0),
              child: Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: defaultToolbarIconColor,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUpperShadow(BuildContext context) {
    return VerticalGradientShadow(
      height: 140,
      alignment: Alignment.topCenter,
      upperColor: Color.fromRGBO(0, 0, 0, 0.55),
      lowerColor: Colors.transparent,
    );
  }

  Widget _buildLowerShadow(BuildContext context) {
    return VerticalGradientShadow(
      height: 400,
      alignment: Alignment.bottomCenter,
      upperColor: Colors.transparent,
      lowerColor: Color.fromRGBO(0, 0, 0, 0.35),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PictureBloc, PictureState>(
      listener: (BuildContext context, PictureState state) async {
        if (state.share != null) {
          await Clipboard.setData(ClipboardData(text: state.share!.url));
        }
        if (state.infoSnackbar != null) {
          showInfoSnackbar(context, state.infoSnackbar!);
        }
      },
      builder: _buildPictureContainer,
    );
  }
}
