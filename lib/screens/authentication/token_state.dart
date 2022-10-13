import 'package:equatable/equatable.dart';
import 'package:potok/resources/models/token.dart';

abstract class TokenState extends Equatable {
  @override
  List<Object> get props => [];
}

class TokenNotReceived extends TokenState {}

class TokenReceived extends TokenState {
  TokenReceived({required this.token});

  Token token;
}
