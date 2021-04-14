import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/widgets/common/animations.dart';

String get unitId {
  if (globals.isDebug) {
    return config.adsDebugUnitId;
  }

  if (Platform.isAndroid) {
    return config.adsAndroidUnitId;
  } else if (Platform.isIOS) {
    return config.adsIosUnitId;
  }
}

class AdsWidget extends StatefulWidget {
  @override
  _AdsWidgetState createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  NativeAd myNative;
  bool isAdLoaded = false;

  @override
  void initState() {
    myNative = NativeAd(
      adUnitId: unitId,
      factoryId: 'adFactoryExample',
      request: AdRequest(),
      listener: AdListener(onAdLoaded: (_) {
        setState(() {
          isAdLoaded = true;
        });
      }),
    );
    myNative.load();
    super.initState();
  }

  @override
  void dispose() {
    myNative.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdLoaded) {
      return Container(
        child: AdWidget(ad: myNative),
      );
    } else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ad is loading",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: "Sofia",
              ),
            ),
            Container(
              height: 10,
            ),
            StyledLoadingIndicator(color: Colors.white),
          ],
        ),
      );
    }
  }
}
