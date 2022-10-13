import 'package:equatable/equatable.dart';

enum LoadableListStatus { initial, loading, success, finished, failure }

extension LoadableListStatusX on LoadableListStatus {
  bool get isInitial => this == LoadableListStatus.initial;

  bool get isLoading => this == LoadableListStatus.loading;

  bool get isSuccess => this == LoadableListStatus.success;

  bool get isFinished => this == LoadableListStatus.finished;

  bool get isFailure => this == LoadableListStatus.failure;
}

class LoadableListState<T> extends Equatable {
  LoadableListState({
    LoadableListStatus status = LoadableListStatus.initial,
    List<T>? list,
    int lastPageLoaded = 0,
  })  : this.list = list ?? [],
        this.status = status,
        this.lastPageLoaded = lastPageLoaded;

  late List<T> list;
  LoadableListStatus status = LoadableListStatus.initial;
  final lastPageLoaded;

  @override
  List<Object?> get props => [list, status, lastPageLoaded];

  LoadableListState<T> copyWith({
    LoadableListStatus? status,
    List<T>? list,
    int? lastPageLoaded,
  }) {
    return LoadableListState<T>(
      status: status ?? this.status,
      list: list ?? this.list,
      lastPageLoaded: lastPageLoaded ?? this.lastPageLoaded,
    );
  }
}
