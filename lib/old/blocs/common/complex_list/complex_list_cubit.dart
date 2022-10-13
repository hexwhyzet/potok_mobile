import 'package:bloc/bloc.dart';
import 'package:potok/blocs/common/complex_list/complex_list_repository.dart';
import 'package:potok/blocs/common/complex_list/complex_list_state.dart';

class ComplexListCubit<E> extends Cubit<ComplexListState<E>> {
  ComplexListCubit({required this.repository})
      : super(const ComplexListState.loading());

  final ComplexListRepository<E> repository;

  Future<void> fetchMore() async {
    try {
      final oldItems = state.items;
      final items = oldItems + await repository.fetchItems(oldItems);
      emit(ComplexListState.success(items));
    } on Exception {
      emit(const ComplexListState.failure());
    }
  }
}
