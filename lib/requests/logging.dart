import 'dart:io';
import 'dart:async';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:potok/config.dart' as config;
import 'package:potok/globals.dart' as globals;
import 'package:potok/models/response.dart';

Future<String> getDeviceId() async {
  String deviceId = await PlatformDeviceId.getDeviceId;
  return deviceId;
}

Map<String, String> authAttributes() {
  Map<String, String> answer = {"auth_token": globals.authToken};
  return answer;
}

Future<bool> getAuthToken() async {
  Map<String, String> params = {"device_id": await getDeviceId()};
  await getRequest(config.authTokenByDeviceId, params, false).then((response) {
    if (response.status == "ok") {
      String authToken = response.jsonContent["auth_token"];
      globals.authToken = authToken;
      globals.isLogged = true;
      return true;
    }
  });
  return false;
}

Future<bool> getSessionToken() async {
  await getRequest(config.createSessionUrl).then((response) {
    if (response.status == "ok") {
      String sessionToken = response.jsonContent["session_token"];
      globals.sessionToken = sessionToken;
      return true;
    }
  });
  return false;
}

Future<bool> loginUser() async {
  bool isAuthTokenReceived = await getAuthToken();
  bool isSessionTokenReceived = await getSessionToken();
  return isAuthTokenReceived & isSessionTokenReceived;
}
