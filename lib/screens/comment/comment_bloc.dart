import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/resources/functions/snackbar.dart';
import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/models/parsed_response.dart';
import 'package:potok/resources/models/share.dart';
import 'package:potok/resources/repositories/comment_repository.dart';
import 'package:potok/screens/comment/comment_event.dart';
import 'package:potok/screens/comment/comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    required int commentId,
    required this.commentRepository,
    Comment? preloadedComment,
  })  : assert(preloadedComment != null
            ? (preloadedComment.id == commentId)
            : true),
        super(
          CommentState(
            commentId: commentId,
            status: preloadedComment != null
                ? CommentStatus.success
                : CommentStatus.initial,
            comment: preloadedComment,
          ),
        ) {
    on<LoadComment>(_mapLoadCommentToState);
    on<UpdateLikeComment>(_mapLikeCommentToState);
    on<ShareComment>(_mapShareCommentToState);
    if (preloadedComment == null) {
      this.add(LoadComment());
    }
  }

  factory CommentBloc.fromPreloadedComment(
      _commentRepository, Comment _preloadedComment) {
    return CommentBloc(
      commentId: _preloadedComment.id,
      commentRepository: _commentRepository,
      preloadedComment: _preloadedComment,
    );
  }

  final CommentRepository commentRepository;

  void _mapLoadCommentToState(
      LoadComment event, Emitter<CommentState> emit) async {
    try {
      ParsedResponse<Comment> response =
          await this.commentRepository.fetchComment(
                this.state.commentId,
              );
      if (response.statusCode != 200 || response.content == null) {
        throw Exception("Failed to load comment");
      }
      emit(this.state.copyWith(
            status: CommentStatus.success,
            comment: response.content,
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to load the comment",
              InfoSnackbarStyle.failure,
            ),
            status: CommentStatus.failure,
          ));
    }
  }

  void _mapLikeCommentToState(
      UpdateLikeComment event, Emitter<CommentState> emit) async {
    String actionName = event.value ? "like" : "dislike";
    if (!this.state.status.isSuccess || this.state.comment == null) return;
    try {
      Response response;
      if (event.value) {
        response =
            await this.commentRepository.likeComment(this.state.commentId);
      } else {
        response =
            await this.commentRepository.dislikeComment(this.state.commentId);
      }
      if (response.statusCode != 204) {
        throw Exception("Wrong status, failed to $actionName comment");
      }
      emit(this.state.copyWith(
            status: CommentStatus.success,
            comment: this.state.comment!.copyWith(
                  likesNum: event.value
                      ? this.state.comment!.likesNum + 1
                      : this.state.comment!.likesNum - 1,
                  isLiked: event.value,
                ),
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to $actionName the comment",
              InfoSnackbarStyle.failure,
            ),
            status: CommentStatus.success,
            comment: this.state.comment,
          ));
    }
  }

  void _mapShareCommentToState(
      ShareComment event, Emitter<CommentState> emit) async {
    try {
      ParsedResponse<Share> parsedResponse =
          await this.commentRepository.shareComment(this.state.commentId);
      if (parsedResponse.statusCode != 200) {
        throw Exception("Wrong status, failed to get share link");
      }
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Share link copied",
              InfoSnackbarStyle.success,
            ),
            comment: this.state.comment?.copyWith(
                  sharesNum: this.state.comment!.sharesNum + 1,
                ),
            share: parsedResponse.content!,
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to share comment the comment",
              InfoSnackbarStyle.failure,
            ),
          ));
    }
  }
}
