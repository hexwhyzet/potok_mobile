import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/models/actions_cacher.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/requests/logging.dart';
import 'package:potok/styles/constraints.dart';
import 'package:potok/widgets/common/animations.dart';
import 'package:potok/widgets/common/bottom_navigation.dart';
import 'package:potok/widgets/registration/registration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // debugPrintGestureArenaDiagnostics = true;
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      globals.trackerManager.sendBack(threshold: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 6),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: AntiGlowingOverscrollIndicator(),
            child: child,
          );
        },
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android:
                CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
            TargetPlatform.iOS:
                CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
          }),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: FutureBuilder<bool>(
          future: loginUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              globals.subscriptionStorage = PictureViewerStorage(
                sourceUrl: config.subscriptionUrl + globals.sessionToken,
                loadMoreNumber: 10,
              );
              globals.feedStorage = TicketStorage(
                sourceUrl: config.tickets,
                loadMoreNumber: 10,
              );
              globals.trackerManager = TrackerManager(
                ticketStorage: globals.feedStorage,
              );
              globals.cacher = Cacher();
              return AppScreen();
            } else {
              return SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: ConstraintsHeights.navigationBarHeight),
                  child: StyledLoadingIndicator(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class AntiGlowingOverscrollIndicator extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
