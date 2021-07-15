import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class StyledAnimatedOpacity extends StatelessWidget {
  final Widget child;
  final bool visible;

  StyledAnimatedOpacity({
    required this.child,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: visible ? 1 : 0,
      child: child,
    );
  }
}

class StyledFadeInImageNetwork extends StatelessWidget {
  final String image;
  final BoxFit fit;

  StyledFadeInImageNetwork({
    required this.image,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      fadeInDuration: Duration(milliseconds: 150),
      fit: this.fit,
      image: this.image,
    );
  }
}

class StyledLoadingIndicator extends StatefulWidget {
  final color;

  StyledLoadingIndicator({this.color});

  @override
  _StyledLoadingIndicatorState createState() => _StyledLoadingIndicatorState();
}

class _StyledLoadingIndicatorState extends State<StyledLoadingIndicator>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: widget.color,
      size: 30,
      lineWidth: 3,
      duration: Duration(milliseconds: 600),
    );
  }
}
