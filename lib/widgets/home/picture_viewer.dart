import 'dart:math';

import 'package:flutter/material.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/models/ads.dart';
import 'package:potok/models/picture.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/ticket.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/widgets/ads/ads.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/navigator_push.dart';
import 'package:potok/widgets/home/actions_toolbar.dart';
import 'package:potok/widgets/home/custom_scroll_physics.dart';
import 'package:preload_page_view/preload_page_view.dart';

class PictureViewerScreen extends StatefulWidget {
  final PictureViewerStorage storage;
  final bool showProfileAvatar;

  PictureViewerScreen({Key key, @required this.storage, this.showProfileAvatar})
      : super(key: key);

  @override
  _PictureViewerScreenState createState() => _PictureViewerScreenState();
}

class _PictureViewerScreenState extends State<PictureViewerScreen> {

  void showInterface() {
    setState(() {
      globals.isVisibleInterface = true;
    });
  }

  void hideInterface() {
    setState(() {
      globals.isVisibleInterface = false;
    });
  }

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
          addCommentUrlProvider: () => widget.storage
              .getObject(widget.storage.lastPosition)
              .addCommentUrl,
          updateComments: () {
            widget.storage.getObject(widget.storage.lastPosition).commentsNum +=
                1;
            setState(() {});
          },
          staticCommentSectionColor: theme.colors.pictureViewerCommentSection,
          staticCommentSectionTextStyle:
              theme.texts.pictureViewerCommentSection,
          dynamicCommentSectionTextStyle: theme.texts.yourCommentDark,
        ),
      ),
      body: GestureDetector(
        child: PictureViewer(
          storage: this.widget.storage,
          showProfileAvatar: this.widget.showProfileAvatar,
          hideBackArrowAndCommentSection: hideInterface,
          showBackArrowAndCommentSection: showInterface,
        ),
        onLongPressStart: (LongPressStartDetails details) {
          hideInterface();
        },
        onLongPressEnd: (LongPressEndDetails details) {
          showInterface();
        },
      ),
    );
  }
}

class PictureViewer extends StatefulWidget {
  final storage;
  final double bottomPadding;
  final bool showProfileAvatar;
  final TrackerManager trackerManager;
  Function hideBackArrowAndCommentSection;
  Function showBackArrowAndCommentSection;
  Function hideActionsToolbar;
  Function showActionsToolbar;

  PictureViewer(
      {Key key,
      @required this.storage,
      this.bottomPadding = 0,
      this.showProfileAvatar = true,
      this.trackerManager,
      this.hideBackArrowAndCommentSection,
      this.showBackArrowAndCommentSection,
      this.hideActionsToolbar,
      this.showActionsToolbar})
      : super(key: key);

  @override
  PictureViewerState createState() => PictureViewerState();
}

class PictureViewerState extends State<PictureViewer> {
  PreloadPageController controller;

  void hideInterface() {
    if (widget.hideBackArrowAndCommentSection != null) {
      widget.hideBackArrowAndCommentSection();
    }
    if (widget.hideActionsToolbar != null) {
      widget.hideActionsToolbar();
    }
  }

  void showInterface() {
    if (widget.showBackArrowAndCommentSection != null) {
      widget.showBackArrowAndCommentSection();
    }
    if (widget.showActionsToolbar != null) {
      widget.showActionsToolbar();
    }
  }

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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
          return SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: AdsWidget(),
          );
        }
        if (position == 0 && widget.storage.size() == 0) {
          return emptyPage;
        }
        if (widget.trackerManager != null) {
          return RequestedPicture(
            picture: widget.storage.getObject(position).picture,
            bottomPadding: widget.bottomPadding,
            showProfileAvatar: widget.showProfileAvatar,
            tracker: widget.trackerManager.getTracker(position),
            hideInterface: hideInterface,
            showInterface: showInterface,
          );
        }
        return RequestedPicture(
          picture: widget.storage.getObject(position),
          bottomPadding: widget.bottomPadding,
          showProfileAvatar: widget.showProfileAvatar,
          hideInterface: hideInterface,
          showInterface: showInterface,
        );
      },
      itemCount: max(widget.storage.size(), 1),
      onPageChanged: (int position) {
        widget.storage.updateLastPosition(position);
        if (widget.trackerManager != null) {
          widget.trackerManager.updateView(position);
          widget.trackerManager.sendBack();
        }
        if (widget.storage.getObject(position) is Picture ||
            widget.storage.getObject(position) is Ticket) {
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

  @override
  Widget build(BuildContext context) {
    controller = PreloadPageController(
        initialPage: widget.storage.lastPosition, keepPage: false);
    if (widget.storage.size() > 0) {
      return preloadPageViewWidget;
    } else {
      return firstLoading;
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
    return StyledAnimatedOpacity(
      visible: globals.isVisibleInterface,
      child:  Column(
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
      ),
    );
  }
}

class PictureContainer extends StatefulWidget {
  final String pictureUrl;
  Function hideInterface;
  Function showInterface;


  PictureContainer({
    @required this.pictureUrl,
    this.hideInterface,
    this.showInterface,
  });

  @override
  _PictureContainerState createState() => _PictureContainerState();
}

class _PictureContainerState extends State<PictureContainer> with TickerProviderStateMixin {
  final TransformationController _transformationController =
  TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    widget.hideInterface();
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    widget.showInterface();
    _animateResetInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colors.pictureViewerBackgroundColor,
      alignment: Alignment.center,
      child: InteractiveViewer(
        alignPanAxis: false,
          panEnabled: false,
          transformationController: _transformationController,
          onInteractionStart: _onInteractionStart,
          onInteractionEnd: _onInteractionEnd,
          boundaryMargin: EdgeInsets.all(double.infinity),
          minScale: 0.75,
          maxScale: 3.0,
          clipBehavior: Clip.none,
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
                  image: widget.pictureUrl,
                ),
              ),

            ],
          ),
      ),
    );
  }
}

class RequestedPicture extends StatefulWidget {
  final Picture picture;
  final double bottomPadding;
  final bool showProfileAvatar;
  final Tracker tracker;
  Function hideInterface;
  Function showInterface;

  RequestedPicture({
    @required this.picture,
    this.bottomPadding = 0,
    this.showProfileAvatar = true,
    this.tracker,
    this.hideInterface,
    this.showInterface,
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
              hideInterface: widget.hideInterface,
              showInterface: widget.showInterface,
            ),
            IgnorePointer(
              child: upperShadow,
            ),
            IgnorePointer(
              child: lowerShadow,
            ),
            IgnorePointer(
              child: StyledAnimatedOpacity(
                visible: globals.isVisibleInterface,
                child: ActionsToolbar(
                  picture: widget.picture,
                  bottomPadding: 0,
                  showProfile: widget.showProfileAvatar,
                  tracker: widget.tracker,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
