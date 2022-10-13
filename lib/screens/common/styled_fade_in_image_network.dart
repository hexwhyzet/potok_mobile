import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
