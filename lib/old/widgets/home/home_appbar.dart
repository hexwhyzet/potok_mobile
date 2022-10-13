import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
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
        padding: EdgeInsets.all(45),
        alignment: Alignment.center,
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
          indicatorSize: TabBarIndicatorSize.label,
          // indicator: UnderlineTabIndicator(
          //   borderSide: BorderSide(
          //     width: 5,
          //     color: theme.colors.secondaryColor,
          //   ),
          // ),
          indicator: CustomTabIndicator(),
          labelStyle: globals.theme.texts.homeScreenAppBarSelected,
          labelColor: globals.theme.texts.homeScreenAppBarSelected.color,
          unselectedLabelStyle: globals.theme.texts.homeScreenAppBarUnSelected,
          unselectedLabelColor: globals.theme.texts.homeScreenAppBarUnSelected.color,
          tabs: <Widget>[
            Container(
              // padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
              child: Text(
                "following",
              ),
            ),
            Container(
              // padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
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

class CustomTabIndicator extends Decoration {

  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }

}

class _CustomPainter extends BoxPainter {

  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = Offset(offset.dx + configuration.size.width / 4, offset.dy) & Size(configuration.size.width / 2, 4);
    final Paint paint = Paint();
    paint.color = theme.colors.secondaryColor.withOpacity(0.95);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(5.0)), paint);
  }
}
