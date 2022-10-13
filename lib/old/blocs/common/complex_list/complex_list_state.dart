import 'package:equatable/equatable.dart';

enum ListStatus { loading, success, failure }

class ComplexListState<E> extends Equatable {
  const ComplexListState._({
    this.status = ListStatus.loading,
    this.items = const [],
  });

  const ComplexListState.loading() : this._();

  const ComplexListState.success(List<E> items)
      : this._(status: ListStatus.success, items: items);

  const ComplexListState.failure() : this._(status: ListStatus.failure);

  final ListStatus status;
  final List<E> items;

  @override
  List<Object> get props => [status, items];
}
