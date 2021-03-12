import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/requests/logging.dart';
import 'package:potok/widgets/common/animations.dart';


String get unitId {
  if (Platform.isAndroid) {
    return config.adsAndroidUnitId;
  } else if (Platform.isIOS) {
    return config.adsIosUnitId;
  }
}

class Ads extends StatefulWidget {


  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  NativeAd myNative;

  @override
  void initState() {
    myNative = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'adFactoryExample',
      request: AdRequest(
          testDevices: ["210fa3a81f233e19a5f2e550c7f37160"]
      ),
      listener: AdListener(),
    );
    super.initState();
  }

  @override
  void dispose() {
    myNative.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myNative.load(),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          width: 500,
          height: 500,
          child: AdWidget(ad: myNative),
        );
        if (snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            width: 500,
            height: 500,
            child: AdWidget(ad: myNative),
          );
        } else {
          return StyledLoadingIndicator(color: Colors.green);
        }
      },
    );
  }
}
