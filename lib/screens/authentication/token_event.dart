import 'package:equatable/equatable.dart';
import 'package:potok/resources/models/token.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class LoadTokenFromStorage extends TokenEvent {}

class SaveToken extends TokenEvent {
  SaveToken({required this.token, this.isAnonymous = false});

  final Token token;
  final bool isAnonymous;

  @override
  List<Object> get props => [token];
}

class Logout extends TokenEvent {}

class ReceiveAnonymousToken extends TokenEvent {}
