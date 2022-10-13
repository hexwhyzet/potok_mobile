import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/models/picture.dart';

class LoadMoreResponse<T> {
  LoadMoreResponse({
    required this.newElements,
    required this.hasMore,
  });

  final List<T> newElements;
  final bool hasMore;
}

class LoadMorePicturesResponse extends LoadMoreResponse<Picture> {
  LoadMorePicturesResponse({
    required newElements,
    required hasMore,
  }) : super(newElements: newElements, hasMore: hasMore);

  factory LoadMorePicturesResponse.fromJson(Map<String, dynamic> json) {
    return LoadMorePicturesResponse(
      newElements:
          (json['results'] as List).map((e) => Picture.fromJson(e)).toList(),
      hasMore: json['next'] != null,
    );
  }
}

class LoadMoreCommentsResponse extends LoadMoreResponse<Comment> {
  LoadMoreCommentsResponse({
    required newElements,
    required hasMore,
  }) : super(newElements: newElements, hasMore: hasMore);

  factory LoadMoreCommentsResponse.fromJson(Map<String, dynamic> json) {
    return LoadMoreCommentsResponse(
      newElements:
          (json['results'] as List).map((e) => Comment.fromJson(e)).toList(),
      hasMore: json['next'] != null,
    );
  }
}
