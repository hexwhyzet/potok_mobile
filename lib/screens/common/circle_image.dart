import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/screens/common/shimmer.dart';
import 'package:potok/screens/common/styled_fade_in_image_network.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
    required this.radius,
    required this.imageUrl,
    required this.isLoading,
  }) : super(key: key);

  final double radius;
  final String imageUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.radius),
        child: Container(
          width: this.radius * 2,
          height: this.radius * 2,
          child: Stack(
            children: [
              ShimmerLoading(
                isLoading: true,
                child: Container(
                  decoration: new BoxDecoration(color: Colors.red),
                ),
              ),
              if (!this.isLoading)
                StyledFadeInImageNetwork(
                  image: this.imageUrl,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
