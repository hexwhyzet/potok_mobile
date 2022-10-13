import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/resources/models/loadable_list.dart';
import 'package:potok/resources/repositories/loadable_list_repository.dart';
import 'package:potok/screens/loadable_list/loadable_list_event.dart';
import 'package:potok/screens/loadable_list/loadable_list_state.dart';

class LoadableListBloc<T>
    extends Bloc<LoadableListEvent, LoadableListState<T>> {
  int pageSize;

  LoadableListBloc(
      {required LoadableListRepository<T> repository, pageSize = 10})
      : this._repository = repository,
        this.pageSize = pageSize,
        super(LoadableListState()) {
    on<LoadMore>(_mapLoadMoreState);
    add(LoadMore(state.lastPageLoaded + 1));
  }

  final LoadableListRepository<T> _repository;

  void _mapLoadMoreState(LoadMore event,
      Emitter<LoadableListState> emit) async {
    if (this.state.status.isFinished) return;
    emit(this.state.copyWith(status: LoadableListStatus.loading));
    final newPage = event.pageToLoad;
    LoadMoreResponse<T> loadMoreResponse = await _repository.loadMore(
        newPage);
    if (newPage > this.state.lastPageLoaded) {
      List<T> newList = this.state.list;
      newList.addAll(loadMoreResponse.newElements);
      emit(this.state.copyWith(
        status: loadMoreResponse.hasMore
            ? LoadableListStatus.success
            : LoadableListStatus.finished,
        list: newList,
        lastPageLoaded: newPage,
      ));
    }
  }
}
