import 'package:bloc/bloc.dart';
import 'package:potok/resources/models/token.dart';
import 'package:potok/resources/repositories/authentication_repository.dart';
import 'package:potok/resources/repositories/token_repository.dart';
import 'package:potok/screens/authentication/token_event.dart';
import 'package:potok/screens/authentication/token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(TokenNotReceived()) {
    on<LoadTokenFromStorage>(_mapLoadTokenFromStorageToState);
    on<SaveToken>(_mapSaveTokenToState);
    on<Logout>(_mapLogoutToState);
    on<ReceiveAnonymousToken>(_mapReceiveAnonymousToken);

    add(LoadTokenFromStorage());
  }

  final AuthenticationRepository _authenticationRepository;

  final TokenRepository tokenRepository = TokenRepository();

  void _mapLoadTokenFromStorageToState(
      LoadTokenFromStorage event, Emitter<TokenState> emit) async {
    if (await tokenRepository.doesTokenExist()) {
      Token token = await tokenRepository.getToken();
      add(SaveToken(token: token));
    } else {
      add(ReceiveAnonymousToken());
    }
  }

  void _mapSaveTokenToState(SaveToken event, Emitter<TokenState> emit) async {
    await tokenRepository.writeToken(event.token);
    emit(TokenReceived(token: event.token));
  }

  void _mapLogoutToState(Logout event, Emitter<TokenState> emit) async {
    await tokenRepository.deleteToken();
    emit(TokenNotReceived());
    add(ReceiveAnonymousToken());
  }

  void _mapReceiveAnonymousToken(
      ReceiveAnonymousToken event, Emitter<TokenState> emit) async {
    Token token = await _authenticationRepository.anonymous();
    add(SaveToken(token: token));
  }
}
