import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:potok/resources/models/token.dart';

const TOKEN_KEY = 'token';
const IS_ANONYMOUS_KEY = 'is_anonymous';

class TokenRepository {
  Future<bool> doesTokenExist() async {
    final storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();
    return allValues.containsKey(TOKEN_KEY) &&
        allValues.containsKey(IS_ANONYMOUS_KEY);
  }

  Future<Token> getToken() async {
    final storage = FlutterSecureStorage();
    return Token(
        token: (await storage.read(key: TOKEN_KEY))!,
        isAnonymous: (await storage.read(key: IS_ANONYMOUS_KEY))! == 'true');
  }

  Future<void> writeToken(Token token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: TOKEN_KEY, value: token.token);
    await storage.write(
        key: IS_ANONYMOUS_KEY, value: token.isAnonymous.toString());
  }

  Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: TOKEN_KEY);
    await storage.delete(key: IS_ANONYMOUS_KEY);
  }
}
