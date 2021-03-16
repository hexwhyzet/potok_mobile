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
    this.child,
    this.visible,
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
    @required this.image,
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

class FadeIn extends StatelessWidget {
  final Duration delay;
  final Widget child;
  final Duration duration;

  FadeIn(this.delay, this.duration, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(duration, Tween(begin: 0.0, end: 1.0)),
      Track("translateX")
          .add(duration, Tween(begin: 200.0, end: 0.0), curve: Curves.easeIn)
    ]);

    return ControlledAnimation(
      delay: delay,
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}
