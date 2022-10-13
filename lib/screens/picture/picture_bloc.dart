import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/resources/functions/snackbar.dart';
import 'package:potok/resources/models/parsed_response.dart';
import 'package:potok/resources/models/picture.dart';
import 'package:potok/resources/models/share.dart';
import 'package:potok/resources/repositories/picture_repository.dart';
import 'package:potok/screens/picture/picture_event.dart';
import 'package:potok/screens/picture/picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc({
    required int pictureId,
    required this.pictureRepository,
    Picture? preloadedPicture,
  })  : assert(preloadedPicture != null
            ? (preloadedPicture.id == pictureId)
            : true),
        super(
          PictureState(
            pictureId: pictureId,
            status: preloadedPicture != null
                ? PictureStatus.success
                : PictureStatus.initial,
            picture: preloadedPicture,
          ),
        ) {
    on<LoadPicture>(_mapLoadPictureToState);
    on<UpdateLikePicture>(_mapLikePictureToState);
    on<SharePicture>(_mapSharePictureToState);
    if (preloadedPicture == null) {
      this.add(LoadPicture());
    }
  }

  factory PictureBloc.fromPreloadedPicture(
      _pictureRepository, Picture _preloadedPicture) {
    return PictureBloc(
      pictureId: _preloadedPicture.id,
      pictureRepository: _pictureRepository,
      preloadedPicture: _preloadedPicture,
    );
  }

  final PictureRepository pictureRepository;

  void _mapLoadPictureToState(
      LoadPicture event, Emitter<PictureState> emit) async {
    try {
      ParsedResponse<Picture> response =
          await this.pictureRepository.fetchPicture(
                this.state.pictureId,
              );
      if (response.statusCode != 200 || response.content == null) {
        throw Exception("Failed to load picture");
      }
      emit(this.state.copyWith(
            status: PictureStatus.success,
            picture: response.content,
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to load the picture",
              InfoSnackbarStyle.failure,
            ),
            status: PictureStatus.failure,
          ));
    }
  }

  void _mapLikePictureToState(
      UpdateLikePicture event, Emitter<PictureState> emit) async {
    String actionName = event.value ? "like" : "dislike";
    if (!this.state.status.isSuccess || this.state.picture == null) return;
    try {
      Response response;
      if (event.value) {
        response =
            await this.pictureRepository.likePicture(this.state.pictureId);
      } else {
        response =
            await this.pictureRepository.dislikePicture(this.state.pictureId);
      }
      if (response.statusCode != 204) {
        throw Exception("Wrong status, failed to $actionName picture");
      }
      emit(this.state.copyWith(
            status: PictureStatus.success,
            picture: this.state.picture!.copyWith(
                  likesNum: event.value
                      ? this.state.picture!.likesNum + 1
                      : this.state.picture!.likesNum - 1,
                  isLiked: event.value,
                ),
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to $actionName the picture",
              InfoSnackbarStyle.failure,
            ),
            status: PictureStatus.success,
            picture: this.state.picture,
          ));
    }
  }

  void _mapSharePictureToState(
      SharePicture event, Emitter<PictureState> emit) async {
    try {
      ParsedResponse<Share> parsedResponse =
          await this.pictureRepository.sharePicture(this.state.pictureId);
      if (parsedResponse.statusCode != 200) {
        throw Exception("Wrong status, failed to get share link");
      }
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Share link copied",
              InfoSnackbarStyle.success,
            ),
            picture: this.state.picture?.copyWith(
                sharesNum: this.state.picture!.sharesNum + 1,
            ),
            share: parsedResponse.content!,
          ));
    } catch (e) {
      emit(this.state.copyWith(
            infoSnackbar: InfoSnackbar(
              "Failed to share picture the picture",
              InfoSnackbarStyle.failure,
            ),
          ));
    }
  }
}
