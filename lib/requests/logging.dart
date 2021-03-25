import 'dart:async';
import 'dart:io';

import 'package:flutter_restart/flutter_restart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/models/response.dart';

const TOKEN_KEY = 'token';
const TOKEN_PREFIX = 'Bearer';

Future<bool> doesTokenExist() async {
  final storage = new FlutterSecureStorage();
  Map<String, String> allValues = await storage.readAll();
  return allValues.containsKey(TOKEN_KEY);
}

Future<String> getToken() async {
  final storage = new FlutterSecureStorage();
  return await storage.read(key: TOKEN_KEY);
}

Future<void> writeToken(String token) async {
  final storage = new FlutterSecureStorage();
  await storage.write(key: TOKEN_KEY, value: token);
}

Future<void> deleteToken() async {
  final storage = new FlutterSecureStorage();
  await storage.delete(key: TOKEN_KEY);
}

Future<String> getDeviceId() async {
  String deviceId = await PlatformDeviceId.getDeviceId;
  return deviceId;
}

Future<Map<String, String>> getAuthHeaders() async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "$TOKEN_PREFIX ${await getToken()}"
  };
  return headers;
}

Future<bool> getAnonymousAuthToken() async {
  Map<String, String> body = {"device_id": await getDeviceId()};
  Response response = await postRequest(
      url: config.authTokenByDeviceId, body: body, auth: false);
  if (response.status == 200) {
    String token = response.jsonContent["token"];
    await writeToken(token);
    return true;
  }
  return false;
}

Future<bool> getSessionToken() async {
  Response response = await getRequest(url: config.createSessionUrl);
  if (response.status == 200) {
    String sessionToken = response.jsonContent["session_token"];
    globals.sessionToken = sessionToken;
    return true;
  }
  return false;
}

Future<bool> isUserLogged() async {
  Response response = await getRequest(url: config.isUserLogged);
  if (response.status == 200) {
    bool value = response.jsonContent["is_logged"];
    return value;
  }
  return false;
}

Future<void> logOut() async {
  deleteToken();
  restartApp();
}

Future<void> restartApp() async {
  deleteToken();
  FlutterRestart.restartApp();
}

Future<bool> loginUser() async {
  bool isTokenReceived;
  if (!await doesTokenExist()) {
    isTokenReceived = await getAnonymousAuthToken();
  } else {
    isTokenReceived = true;
  }
  globals.isLogged = await isUserLogged();
  bool isSessionTokenReceived = await getSessionToken();
  return isTokenReceived & isSessionTokenReceived;
}
