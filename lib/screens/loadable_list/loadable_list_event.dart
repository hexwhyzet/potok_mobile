import 'package:equatable/equatable.dart';

abstract class LoadableListEvent {}

class LoadMore extends LoadableListEvent {
  int pageToLoad;

  LoadMore(this.pageToLoad);
}