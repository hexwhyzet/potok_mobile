import 'dart:ui';

import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:potok/configs/constraints.dart';
import 'package:potok/configs/icons.dart';
import 'package:potok/configs/theme_data.dart';
import 'package:potok/screens/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'package:potok/screens/common/interface_visibility_cubit.dart';
import 'package:potok/screens/common/tap_animation.dart';

const Color PICTURE_VIEWER_BACKGROUND_COLOR = BLACK;
const Color PICTURE_VIEWER_SELECTED_ICON_COLOR = WHITE;

class BottomNavigationBarScreen extends StatelessWidget {
  final AnimatorKey<double> homeAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> searchAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> uploadAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> inboxAnimatorKey = AnimatorKey<double>();
  final AnimatorKey<double> profileAnimatorKey = AnimatorKey<double>();

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Container(
        child: Text('One'),
      ),
      Container(
        child: Text('Two'),
      ),
      Container(
        child: Text('Three'),
      ),
      Container(
        child: Text('Four'),
      ),
      Container(
        child: Text('Five'),
      ),
      // HomeScreen(
      //   subscriptionStorage: globals.subscriptionStorage,
      //   feedStorage: globals.feedStorage,
      //   setStateBottomBar: setStateBottomBar,
      //   trackerManager: globals.trackerManager,
      // ),
      // SearchScreen(),
      // UploadPictureScreen(),
      // ActionsScreen(),
      // MyProfileScreen(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBarCubit>(
          create: (BuildContext context) => BottomNavigationBarCubit(),
        ),
      ],
      child: BlocBuilder<BottomNavigationBarCubit, int>(
        builder: (context, selectedTabIndex) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: selectedTabIndex == 0,
            backgroundColor: selectedTabIndex == 0
                ? PICTURE_VIEWER_BACKGROUND_COLOR
                : Theme.of(context).backgroundColor,
            body: _widgetOptions.elementAt(selectedTabIndex),
            bottomNavigationBar: InterfaceVisibilityContent(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border(
                      // top: BorderSide(
                      //   color: Colors.grey.withOpacity(
                      //       (selectedTabIndex != 0) ? 0.4 : 0),
                      //   width: 0.4,
                      // ),
                      // ),
                      color: selectedTabIndex == 0
                          ? PICTURE_VIEWER_BACKGROUND_COLOR.withOpacity(0.8)
                          : Theme.of(context).bottomAppBarTheme.color,
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
                          selectedFontSize: 0,
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: TapAnimation(
                                animatorKey: homeAnimatorKey,
                                child: Icon(AppIcons.home, size: 38),
                              ),
                              label: AppLocalizations.of(context)!.homeTabLabel,
                            ),
                            BottomNavigationBarItem(
                              icon: TapAnimation(
                                animatorKey: searchAnimatorKey,
                                child: Icon(AppIcons.search, size: 38),
                              ),
                              label:
                                  AppLocalizations.of(context)!.searchTabLabel,
                            ),
                            BottomNavigationBarItem(
                              icon: TapAnimation(
                                animatorKey: uploadAnimatorKey,
                                child: Icon(Icons.add_rounded, size: 38),
                              ),
                              label:
                                  AppLocalizations.of(context)!.uploadTabLabel,
                            ),
                            BottomNavigationBarItem(
                              icon: TapAnimation(
                                animatorKey: inboxAnimatorKey,
                                child: Icon(AppIcons.inbox, size: 38),
                              ),
                              label:
                                  AppLocalizations.of(context)!.inboxTabLabel,
                            ),
                            BottomNavigationBarItem(
                              icon: TapAnimation(
                                animatorKey: profileAnimatorKey,
                                child: Icon(AppIcons.profile, size: 38),
                              ),
                              label:
                                  AppLocalizations.of(context)!.profileTabLabel,
                            ),
                          ],
                          type: BottomNavigationBarType.fixed,
                          elevation: 0,
                          currentIndex: selectedTabIndex,
                          backgroundColor: Colors.transparent,
                          selectedItemColor: selectedTabIndex == 0
                              ? PICTURE_VIEWER_SELECTED_ICON_COLOR
                              : Theme.of(context).selectedRowColor,
                          unselectedItemColor:
                              Theme.of(context).unselectedWidgetColor,
                          onTap: (newSelectedIndex) {
                            [
                              homeAnimatorKey,
                              searchAnimatorKey,
                              uploadAnimatorKey,
                              inboxAnimatorKey,
                              profileAnimatorKey
                            ][newSelectedIndex]
                                .triggerAnimation();
                            context
                                .read<BottomNavigationBarCubit>()
                                .updateIndex(newSelectedIndex);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
