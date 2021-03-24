import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/widgets/registration/registration.dart';


class HomeAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function rebuildSubscription;
  final Function rebuildFeed;
  final TabController _tabController;

  HomeAppBar(
    this.rebuildSubscription,
    this.rebuildFeed,
    this._tabController,
  );

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    // final tabController = DefaultTabController.of(context);

    return AppBar(
      brightness: Brightness.dark,
      // backwardsCompatibility: false,
      // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black, systemNavigationBarColor: Colors.white),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Container(
        child: TabBar(
          controller: widget._tabController,
          onTap: (index) {
            if (widget._tabController.indexIsChanging == false) {
              if (index == 0) {
                widget.rebuildSubscription();
              } else {
                widget.rebuildFeed();
              }
            } else {
              if (index == 0 && !globals.isLogged) {
                showAuthenticationScreen(context);
                widget._tabController.index = 1;
              }
            }
          },
          labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          indicator: BoxDecoration(),
          labelStyle: globals.theme.texts.homeScreenAppBarSelected,
          labelColor: globals.theme.texts.homeScreenAppBarSelected.color,
          unselectedLabelStyle: globals.theme.texts.homeScreenAppBarUnSelected,
          unselectedLabelColor: globals.theme.texts.homeScreenAppBarUnSelected.color,
          tabs: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "following",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "for you",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
