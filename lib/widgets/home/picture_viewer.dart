import 'dart:math';

import 'package:flutter/material.dart';
import 'package:potok/models/ads.dart';
import 'package:potok/widgets/ads/ads.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/models/picture.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/home/actions_toolbar.dart';
import 'package:potok/widgets/home/custom_scroll_physics.dart';

class PictureViewerScreen extends StatefulWidget {
  final PictureViewerStorage storage;
  final bool showProfileAvatar;

  PictureViewerScreen({Key key, @required this.storage, this.showProfileAvatar})
      : super(key: key);

  @override
  _PictureViewerScreenState createState() => _PictureViewerScreenState();
}

class _PictureViewerScreenState extends State<PictureViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colors.pictureViewerBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.dark,
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white, systemNavigationBarColor: Colors.black),
        leading: StyledAnimatedOpacity(
          visible: globals.isVisibleInterface,
          child: PictureViewerBackArrowButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: StyledAnimatedOpacity(
        visible: globals.isVisibleInterface,
        child: AddComment(
          addCommentUrlProvider: () =>
          widget.storage.getObject(widget.storage.lastPosition).addCommentUrl,
          updateComments: () {
            widget.storage.getObject(widget.storage.lastPosition).commentsNum +=
            1;
            setState(() {});
          },
          staticCommentSectionColor: theme.colors.pictureViewerCommentSection,
          staticCommentSectionTextStyle: theme.texts.pictureViewerCommentSection,
          dynamicCommentSectionTextStyle: theme.texts.yourCommentDark,
        ),
      ),
      body: GestureDetector(
        child: PictureViewer(
          storage: this.widget.storage,
          showProfileAvatar: this.widget.showProfileAvatar,
        ),
        onLongPressStart: (LongPressStartDetails details) {
          setState(() {
            globals.isVisibleInterface = false;
          });
        },
        onLongPressEnd: (LongPressEndDetails details) {
          setState(() {
            globals.isVisibleInterface = true;
          });
        },
      ),
    );
  }
}

class PictureViewer extends StatefulWidget {
  final PictureViewerStorage storage;
  final double bottomPadding;
  final bool showProfileAvatar;

  PictureViewer(
      {Key key,
      @required this.storage,
      this.bottomPadding = 0,
      this.showProfileAvatar = true})
      : super(key: key);

  @override
  PictureViewerState createState() => PictureViewerState();
}

class PictureViewerState extends State<PictureViewer> {
  PreloadPageController controller;

  Widget get emptyPage {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      bottom: true,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.texts.emptyPictureViewer,
                  children: [
                    TextSpan(
                      text: "You have no subscriptions, checkout tab\n\n",
                    ),
                    TextSpan(
                      text: "for you",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get preloadPageViewWidget {
    return PreloadPageView.builder(
      physics: CustomPageViewScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, position) {
        if (widget.storage.getObject(position) is Ads) {
          return AdsWidget();
        }
        if (position == 0 && widget.storage.size() == 0) {
          return emptyPage;
        }
        return RequestedPicture(
          picture: widget.storage.getObject(position),
          bottomPadding: widget.bottomPadding,
          showProfileAvatar: widget.showProfileAvatar,
        );
      },
      itemCount: max(widget.storage.size(), 1),
      onPageChanged: (int position) {
        widget.storage.updateLastPosition(position);
        if (widget.storage.getObject(position) is Picture) {
          widget.storage.markAsSeen(position);
        }
        widget.storage.check().then((value) {
          if (value) setState(() {});
        });
      },
      preloadPagesCount: 3,
      controller: controller,
    );
  }

  Widget get firstLoading {
    return FutureBuilder<void>(
      future: widget.storage.addObjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: Center(
              child: StyledLoadingIndicator(color: Colors.white),
            ),
          );
        } else {
          return preloadPageViewWidget;
        }
      },
    );
  }

  Widget refreshIndicator(Widget inside) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.storage.rebuild().then((_) {
          setState(() {});
        });
        return await Future.delayed(Duration(seconds: 1));
      },
      child: inside,
    );
  }

  @override
  Widget build(BuildContext context) {
    controller = PreloadPageController(
        initialPage: widget.storage.lastPosition, keepPage: false);
    if (widget.storage.size() > 0) {
      return refreshIndicator(preloadPageViewWidget);
    } else {
      return refreshIndicator(firstLoading);
    }
  }
}

class VerticalGradientShadow extends StatelessWidget {
  final double height;
  final Color upperColor;
  final Color lowerColor;
  final Alignment alignment;

  VerticalGradientShadow({
    @required this.height,
    @required this.alignment,
    @required this.upperColor,
    @required this.lowerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: alignment,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [upperColor, lowerColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PictureContainer extends StatelessWidget {
  final String pictureUrl;

  PictureContainer({
    @required this.pictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colors.pictureViewerBackgroundColor,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: StyledLoadingIndicator(
              color: Colors.white,
            ),
          ),
          Center(
            child: StyledFadeInImageNetwork(
              fit: BoxFit.contain,
              image: pictureUrl,
            ),
          ),
        ],
      ),
    );
  }
}

class RequestedPicture extends StatefulWidget {
  final Picture picture;
  final double bottomPadding;
  final bool showProfileAvatar;

  RequestedPicture({
    @required this.picture,
    this.bottomPadding = 0,
    this.showProfileAvatar = true,
  });

  @override
  _RequestedPicture createState() => _RequestedPicture();
}

class _RequestedPicture extends State<RequestedPicture> {
  @override
  void initState() {
    super.initState();
  }

  Widget get upperShadow => VerticalGradientShadow(
        height: 140,
        alignment: Alignment.topCenter,
        upperColor: theme.colors.pictureViewerUpperShadowUpper,
        lowerColor: theme.colors.pictureViewerUpperShadowLower,
      );

  Widget get lowerShadow => VerticalGradientShadow(
        height: 400,
        alignment: Alignment.bottomCenter,
        upperColor: theme.colors.pictureViewerLowerShadowUpper,
        lowerColor: theme.colors.pictureViewerLowerShadowLower,
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        padding: EdgeInsets.only(bottom: widget.bottomPadding),
        child: Stack(
          children: <Widget>[
            PictureContainer(
              pictureUrl: widget.picture.highResUrl,
            ),
            upperShadow,
            lowerShadow,
            StyledAnimatedOpacity(
              visible: globals.isVisibleInterface,
              child: ActionsToolbar(
                widget.picture,
                bottomPadding: 0,
                showProfile: widget.showProfileAvatar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
