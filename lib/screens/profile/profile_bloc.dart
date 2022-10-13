import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/resources/models/profile.dart';
import 'package:potok/resources/models/profile_preview.dart';
import 'package:potok/resources/repositories/profile_repository.dart';
import 'package:potok/screens/profile/profile_event.dart';
import 'package:potok/screens/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRepository profileRepository,
    required int profileId,
  })  : _profileRepository = profileRepository,
        _profileId = profileId,
        super(ProfileState(status: ProfileStatus.initial)) {
    on<LoadProfile>(_mapLoadProfileToState);
    on<SubscriptionButtonPressed>(_mapSubscriptionButtonPressed);
    this.add(LoadProfile());
  }

  final ProfileRepository _profileRepository;
  final int _profileId;

  void _mapLoadProfileToState(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(this.state.copyWith(
          status: this.state.status.isInitial
              ? ProfileStatus.loading
              : ProfileStatus.refreshing,
        ));
    try {
      ProfilePreview profilePreview =
          await this._profileRepository.fetchProfilePreview(this._profileId);
      if (profilePreview.isAvailable) {
        Profile profile =
            await this._profileRepository.fetchProfile(this._profileId);
        emit(this.state.copyWith(
              status: ProfileStatus.success,
              profile: profile,
              profilePreview: profilePreview,
            ));
      } else {
        emit(this.state.copyWith(
              status: ProfileStatus.success,
              subscriptionStatus: ProfileSubscriptionStatus.success,
              profilePreview: profilePreview,
            ));
      }
    } catch (e, stacktrace) {
      log('Error on RefreshProfileEvent: $e, $stacktrace');
      emit(this.state.copyWith(status: ProfileStatus.failure));
    }
  }

  void _mapSubscriptionButtonPressed(
      SubscriptionButtonPressed event, Emitter<ProfileState> emit) async {
    if (this.state.subscriptionStatus.isLoading) return;
    emit(this
        .state
        .copyWith(subscriptionStatus: ProfileSubscriptionStatus.loading));
    try {
      if (this.state.profile!.subscriptionStatus == 0) {
        await this._profileRepository.subscribe(_profileId);
      } else {
        await this._profileRepository.unsubscribe(_profileId);
      }
    } catch (e, stacktrace) {
      log('Error on SubscriptionButtonPressed: $e, $stacktrace');
      emit(this
          .state
          .copyWith(subscriptionStatus: ProfileSubscriptionStatus.failure));
    }
    this.add(LoadProfile());
  }
}
