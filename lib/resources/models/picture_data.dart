enum SizeType { tiny, small, medium, big, huge }

SizeType stringToEnum(String str) {
  switch (str) {
    case 't':
      return SizeType.tiny;
    case 's':
      return SizeType.small;
    case 'm':
      return SizeType.medium;
    case 'b':
      return SizeType.big;
    case 'h':
      return SizeType.huge;
  }
  throw ('Unsupported size type in received picture data, should be one of t/s/m/b/h but got $str');
}

List<SizeType> sortedSizeTypes = [
  SizeType.tiny,
  SizeType.small,
  SizeType.medium,
  SizeType.big,
  SizeType.huge
];

class PictureData {
  final String url;
  final SizeType sizeType;
  final int width;
  final int height;

  PictureData({
    required this.url,
    required this.sizeType,
    required this.width,
    required this.height,
  });

  factory PictureData.fromJson(Map<String, dynamic> json) {
    return PictureData(
      url: json['url'],
      sizeType: stringToEnum(json['size_type']),
      width: json['width'],
      height: json['height'],
    );
  }
}

class PictureDataManager {
  PictureDataManager({required List<PictureData> sizes}) : _sizes = sizes;

  final List<PictureData> _sizes;

  PictureData get tiny => getLessOrEqualSize(SizeType.tiny);

  PictureData get small => getLessOrEqualSize(SizeType.small);

  PictureData get medium => getLessOrEqualSize(SizeType.medium);

  PictureData get big => getLessOrEqualSize(SizeType.big);

  PictureData get huge => getLessOrEqualSize(SizeType.huge);

  PictureData getLessOrEqualSize(SizeType sizeType) {
    bool Function(PictureData) sizeTypeMatch =
        (element) => element.sizeType == sizeType;
    if (this._sizes.any(sizeTypeMatch)) {
      return this._sizes.firstWhere(sizeTypeMatch);
    } else {
      if (sizeType == SizeType.tiny) {
        throw ('No such size found.');
      }
      return getLessOrEqualSize(sortedSizeTypes.elementAt(
          sortedSizeTypes.indexWhere((element) => element == sizeType) - 1));
    }
  }
}
