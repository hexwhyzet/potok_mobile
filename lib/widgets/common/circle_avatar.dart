import 'package:flutter/cupertino.dart';
import 'package:potok/models/profile.dart';

import 'animations.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final Profile profile;

  CustomCircleAvatar({this.profile, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        child: StyledFadeInImageNetwork(
          image: profile.avatarUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
