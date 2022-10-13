import 'package:flutter/src/widgets/framework.dart';
import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/models/loadable_list.dart';
import 'package:potok/resources/models/picture.dart';
import 'package:potok/resources/repositories/picture_repository.dart';
import 'package:potok/resources/repositories/repository_base.dart';
import 'package:potok/screens/comment/comment_bloc.dart';
import 'package:potok/screens/picture/picture_bloc.dart';

import 'comment_repository.dart';

abstract class LoadableListRepository<T> extends RepositoryBase {
  LoadableListRepository(BuildContext context) : super(context);

  Future<LoadMoreResponse<T>> loadMore(int page) {
    throw UnimplementedError();
  }
}

class ProfilePicturesLoadableListRepository
    extends LoadableListRepository<Picture> {
  ProfilePicturesLoadableListRepository(BuildContext context,
      {required this.profileId, required this.pictureRepository})
      : super(context);

  final int profileId;
  final PictureRepository pictureRepository;

  @override
  Future<LoadMoreResponse<Picture>> loadMore(int page) async {
    return await pictureRepository.fetchProfilePictures(profileId, page);
  }
}

class ProfilePictureBlocsLoadableListRepository
    extends LoadableListRepository<PictureBloc> {
  ProfilePictureBlocsLoadableListRepository(BuildContext context,
      {required profileId, required pictureRepository})
      : _rawPictureRepository = ProfilePicturesLoadableListRepository(
          context,
          profileId: profileId,
          pictureRepository: pictureRepository,
        ),
        _pictureRepository = pictureRepository,
        super(context);

  final ProfilePicturesLoadableListRepository _rawPictureRepository;
  final PictureRepository _pictureRepository;

  @override
  Future<LoadMoreResponse<PictureBloc>> loadMore(int page) async {
    LoadMoreResponse<Picture> loadMoreResponse =
        await _rawPictureRepository.loadMore(page);
    List<Picture> pictures = loadMoreResponse.newElements;
    List<PictureBloc> pictureBlocs = pictures
        .map((picture) =>
            PictureBloc.fromPreloadedPicture(_pictureRepository, picture))
        .toList();
    return LoadMoreResponse<PictureBloc>(
      newElements: pictureBlocs,
      hasMore: loadMoreResponse.hasMore,
    );
  }
}

class PictureCommentsLoadableListRepository
    extends LoadableListRepository<Comment> {
  PictureCommentsLoadableListRepository(BuildContext context,
      {required this.pictureId, required this.commentRepository})
      : super(context);

  final int pictureId;
  final CommentRepository commentRepository;

  @override
  Future<LoadMoreResponse<Comment>> loadMore(int page) async {
    return await commentRepository.fetchPictureComments(pictureId, page);
  }
}

class PictureCommentsBlocsLoadableListRepository
    extends LoadableListRepository<CommentBloc> {
  PictureCommentsBlocsLoadableListRepository(BuildContext context,
      {required pictureId, required commentRepository})
      : _rawCommentRepository = PictureCommentsLoadableListRepository(
          context,
          pictureId: pictureId,
          commentRepository: commentRepository,
        ),
        _commentRepository = commentRepository,
        super(context);

  final PictureCommentsLoadableListRepository _rawCommentRepository;
  final CommentRepository _commentRepository;

  @override
  Future<LoadMoreResponse<CommentBloc>> loadMore(int page) async {
    LoadMoreResponse<Comment> loadMoreResponse =
        await _rawCommentRepository.loadMore(page);
    List<Comment> comments = loadMoreResponse.newElements;
    List<CommentBloc> commentBlocs = comments
        .map((comment) =>
            CommentBloc.fromPreloadedComment(_commentRepository, comment))
        .toList();
    return LoadMoreResponse<CommentBloc>(
      newElements: commentBlocs,
      hasMore: loadMoreResponse.hasMore,
    );
  }
}
