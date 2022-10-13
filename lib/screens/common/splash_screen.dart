import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  final Color color;

  SplashScreen({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SpinKitRing(
        color: color,
        size: 30,
        lineWidth: 3,
        duration: Duration(milliseconds: 600),
      ),
    );
  }
}