import 'package:equatable/equatable.dart';
import 'package:potok/resources/functions/snackbar.dart';
import 'package:potok/resources/models/picture.dart';
import 'package:potok/resources/models/share.dart';

enum PictureStatus { initial, loading, success, failure }

extension PictureStatusX on PictureStatus {
  bool get isInitial => this == PictureStatus.initial;

  bool get isLoading => this == PictureStatus.loading;

  bool get isSuccess => this == PictureStatus.success;

  bool get isFailure => this == PictureStatus.failure;
}

class PictureState extends Equatable {
  PictureState({
    this.infoSnackbar,
    required this.pictureId,
    this.status = PictureStatus.initial,
    this.picture,
    this.share,
  });

  final InfoSnackbar? infoSnackbar;
  final int pictureId;
  final PictureStatus status;
  final Picture? picture;
  final Share? share;

  PictureState copyWith({
    InfoSnackbar? infoSnackbar,
    PictureStatus? status,
    Picture? picture,
    Share? share,
  }) {
    return PictureState(
      infoSnackbar: infoSnackbar,
      pictureId: this.pictureId,
      status: status ?? this.status,
      picture: picture ?? this.picture,
      share: share,
    );
  }

  @override
  List<Object?> get props => [infoSnackbar, pictureId, status, picture, share];
}
