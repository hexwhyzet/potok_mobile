import 'dart:developer';

import 'package:potok/resources/models/picture_data.dart';

class Avatar {
  final int id;
  final int date;
  final PictureDataManager sizes;

  Avatar({
    required this.id,
    required this.date,
    required this.sizes,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    var sizesListJson = json['sizes'] as List;
    List<PictureData> sizes = List<PictureData>.from(
        sizesListJson.map((i) => PictureData.fromJson(i)));
    return Avatar(
      id: json['id'],
      date: json['date'],
      sizes: PictureDataManager(sizes: sizes),
    );
  }
}
