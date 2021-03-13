import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/widgets/common/animations.dart';

String get unitId {
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

  @override
  void initState() {
    myNative = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'adFactoryExample',
      request: AdRequest(testDevices: ["210fa3a81f233e19a5f2e550c7f37160"]),
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
    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: true,
      child: FutureBuilder(
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Ads is loading",
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
        },
      ),
    );
  }
}
