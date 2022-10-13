import 'package:equatable/equatable.dart';
import 'package:potok/resources/models/profile.dart';
import 'package:potok/resources/models/profile_preview.dart';

enum ProfileStatus { initial, loading, refreshing, success, failure }

extension ProfileStatusX on ProfileStatus {
  bool get isInitial => this == ProfileStatus.initial;

  bool get isLoading => this == ProfileStatus.loading;

  bool get isRefreshing => this == ProfileStatus.refreshing;

  bool get isSuccess => this == ProfileStatus.success;

  bool get isFailure => this == ProfileStatus.failure;
}

enum ProfileSubscriptionStatus { loading, success, failure }

extension ProfileSubscriptionStatusX on ProfileSubscriptionStatus {
  bool get isLoading => this == ProfileSubscriptionStatus.loading;

  bool get isSuccess => this == ProfileSubscriptionStatus.success;

  bool get isFailure => this == ProfileSubscriptionStatus.failure;
}

class ProfileState extends Equatable {
  ProfileState({
    this.status = ProfileStatus.initial,
    this.subscriptionStatus = ProfileSubscriptionStatus.success,
    this.profile,
    this.profilePreview,
  });

  late ProfileStatus status;
  late ProfileSubscriptionStatus subscriptionStatus;
  Profile? profile;
  ProfilePreview? profilePreview;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileSubscriptionStatus? subscriptionStatus,
    Profile? profile,
    ProfilePreview? profilePreview,
  }) {
    return ProfileState(
      status: status ?? this.status,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      profile: profile ?? this.profile,
      profilePreview: profilePreview ?? this.profilePreview,
    );
  }

  @override
  List<Object?> get props => [this.status, this.profilePreview, this.profile];
}
