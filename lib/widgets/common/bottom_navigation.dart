import 'dart:ui';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:potok/globals.dart' as globals;
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/actions/actions_screen.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/home/actions_toolbar.dart';
import 'package:potok/widgets/home/home_screen.dart';
import 'package:potok/widgets/profile/profile_screen.dart';
import 'package:potok/widgets/registration/registration.dart';
import 'package:potok/widgets/search/search_screen.dart';
import 'package:potok/widgets/upload/upload_picture.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;

  final AnimatorKey<double> homeAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> searchAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> uploadAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> inboxAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> profileAnimatorKey = AnimatorKey<double>();

  List<AnimatorKey<double>> animatorKeys;

  void _onItemTapped(int index) {
    [
      homeAnimatorKey,
      searchAnimatorKey,
      uploadAnimatorKey,
      inboxAnimatorKey,
      profileAnimatorKey
    ][index]
        .triggerAnimation();
    if (index > 1 && !globals.isLogged) {
      showAuthenticationScreen(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  setStateBottomBar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        subscriptionStorage: globals.subscriptionStorage,
        feedStorage: globals.feedStorage,
        setStateBottomBar: setStateBottomBar,
        trackerManager: globals.trackerManager,
      ),
      SearchScreen(),
      UploadPictureScreen(),
      ActionsScreen(),
      MyProfileScreen(),
    ];

    // if (_selectedIndex == 0) {
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //       statusBarColor: Colors.black
    //   ));
    // } else {
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //       statusBarColor: Colors.white
    //   ));
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: _selectedIndex == 0,
      backgroundColor: _selectedIndex == 0
          ? theme.colors.pictureViewerBackgroundColor
          : theme.colors.backgroundColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: StyledAnimatedOpacity(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.grey
                            .withOpacity((_selectedIndex != 0) ? 0.4 : 0),
                        width: 0.4)),
                color: _selectedIndex == 0
                    ? theme.colors.pictureViewerBackgroundColor.withOpacity(0.8)
                    : theme.colors.appBarColor.withOpacity(1.0),
              ),
              child: SafeArea(
                top: false,
                right: false,
                left: false,
                bottom: true,
                child: SizedBox(
                  height: ConstraintsHeights.navigationBarHeight,
                  child: BottomNavigationBar(
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: TapAnimation(
                          animatorKey: homeAnimatorKey,
                          child: Icon(AppIcons.home, size: 38),
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: TapAnimation(
                          animatorKey: searchAnimatorKey,
                          child: Icon(AppIcons.search, size: 38),
                        ),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: TapAnimation(
                          animatorKey: uploadAnimatorKey,
                          child: Icon(Icons.add_rounded, size: 38),
                        ),
                        label: 'Upload',
                      ),
                      BottomNavigationBarItem(
                        icon: TapAnimation(
                          animatorKey: inboxAnimatorKey,
                          child: Icon(AppIcons.inbox, size: 38),
                        ),
                        label: 'Inbox',
                      ),
                      BottomNavigationBarItem(
                        icon: TapAnimation(
                          animatorKey: profileAnimatorKey,
                          child: Icon(AppIcons.profile, size: 38),
                        ),
                        label: 'Profile',
                      ),
                    ],
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    currentIndex: _selectedIndex,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: _selectedIndex == 0
                        ? theme.texts.pictureViewerBottomNavigationBarSelected
                            .color
                        : theme.texts.bottomNavigationBarSelected.color,
                    selectedLabelStyle: _selectedIndex == 0
                        ? theme.texts.pictureViewerBottomNavigationBarSelected
                        : theme.texts.pictureViewerBottomNavigationBarSelected,
                    unselectedItemColor: _selectedIndex == 0
                        ? theme.texts.pictureViewerBottomNavigationBarUnSelected
                            .color
                        : theme.texts.bottomNavigationBarUnSelected.color,
                    unselectedLabelStyle: _selectedIndex == 0
                        ? theme.texts.pictureViewerBottomNavigationBarUnSelected
                        : theme.texts.bottomNavigationBarUnSelected,
                    onTap: _onItemTapped,
                  ),
                ),
              ),
            ),
          ),
        ),
        visible: globals.isVisibleInterface,
      ),
    );
  }
}
