import 'package:flutter/material.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/home/home_appbar.dart';
import 'package:potok/widgets/home/picture_viewer.dart';

class HomeScreen extends StatefulWidget {
  final PictureViewerStorage subscriptionStorage;
  final TicketStorage feedStorage;
  final Function setStateBottomBar;
  final TrackerManager trackerManager;

  HomeScreen(
      {@required this.subscriptionStorage,
      @required this.feedStorage,
      @required this.setStateBottomBar,
      this.trackerManager});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  GlobalKey<PictureViewerState> subscriptionKey =
      GlobalKey<PictureViewerState>();
  GlobalKey<PictureViewerState> feedKey = GlobalKey<PictureViewerState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: globals.isLogged ? globals.homeScreenTabIndex : 1, length: 2, vsync: this);
  }

  @override
  void dispose() {
    globals.homeScreenTabIndex = _tabController.index;
    _tabController.dispose();
    super.dispose();
  }

  void rebuildSubscription() {
    widget.subscriptionStorage.rebuild().then((_) {
      setState(() {
        subscriptionKey.currentState.controller.jumpTo(1);
      });
    });
  }

  void rebuildFeed() {
    globals.trackerManager.sendBack(threshold: 0).then((value) {
      widget.feedStorage.rebuild().then((_) {
        setState(() {
          feedKey.currentState.controller.jumpTo(1);
        });
      });
    });

    // feedKey.currentState.controller.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.colors.pictureViewerBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: StyledAnimatedOpacity(
            visible: globals.isVisibleInterface,
            child: HomeAppBar(rebuildSubscription, rebuildFeed, _tabController),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            PictureViewer(
              key: subscriptionKey,
              storage: widget.subscriptionStorage,
              bottomPadding: 0,
            ),
            PictureViewer(
              key: feedKey,
              storage: widget.feedStorage,
              bottomPadding: 0,
              trackerManager: widget.trackerManager,
            ),
          ],
        ),
      ),
      onLongPressStart: (LongPressStartDetails details) {
        setState(() {
          globals.isVisibleInterface = false;
        });
        widget.setStateBottomBar();
      },
      onLongPressEnd: (LongPressEndDetails details) {
        setState(() {
          globals.isVisibleInterface = true;
        });
        widget.setStateBottomBar();
      },
    );
  }
}
