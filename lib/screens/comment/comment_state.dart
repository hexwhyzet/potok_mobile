import 'package:equatable/equatable.dart';
import 'package:potok/resources/functions/snackbar.dart';
import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/models/share.dart';

enum CommentStatus { initial, loading, success, failure }

extension CommentStatusX on CommentStatus {
  bool get isInitial => this == CommentStatus.initial;

  bool get isLoading => this == CommentStatus.loading;

  bool get isSuccess => this == CommentStatus.success;

  bool get isFailure => this == CommentStatus.failure;
}

class CommentState extends Equatable {
  CommentState({
    this.infoSnackbar,
    required this.commentId,
    this.status = CommentStatus.initial,
    this.comment,
    this.share,
  });

  final InfoSnackbar? infoSnackbar;
  final int commentId;
  final CommentStatus status;
  final Comment? comment;
  final Share? share;

  CommentState copyWith({
    InfoSnackbar? infoSnackbar,
    CommentStatus? status,
    Comment? comment,
    Share? share,
  }) {
    return CommentState(
      infoSnackbar: infoSnackbar,
      commentId: this.commentId,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      share: share,
    );
  }

  @override
  List<Object?> get props => [infoSnackbar, commentId, status, comment, share];
}
