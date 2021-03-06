import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/requests/logging.dart';
import 'package:potok/widgets/common/animations.dart';

var myNative = NativeAd(
  adUnitId: "ca-app-pub-3940256099942544/2247696110",
  factoryId: 'adFactoryExample',
  request: AdRequest(),
  listener: AdListener(),
);
var _ = myNative.load();

String get unitId {
  if (Platform.isAndroid) {
    return config.adsAndroidUnitId;
  } else if (Platform.isIOS) {
    return config.adsAndroidUnitId;
  }
}

class Ads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myNative.load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            width: 500,
            height: 500,
            child: AdWidget(ad: myNative),
          );
        } else {
          return StyledLoadingIndicator(color: Colors.white);
        }
      },
    );
  }
}
