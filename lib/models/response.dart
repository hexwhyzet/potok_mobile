import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:potok/requests/logging.dart';

class Response {
  final String status;
  final jsonContent;

  Response({this.status, this.jsonContent});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
      jsonContent: json['content'],
    );
  }
}

String addParameters(String url, Map<String, String> params) {
  url += "?";
  params.forEach((key, value) {
    url += key + "=" + value + "&";
  });
  return url.substring(0, url.length - 1);
}

Future<Response> getRequest(String url,
    [Map<String, String> givenParams = const {}, auth = true]) async {
  Map<String, String> params = {};
  if (auth) params.addAll(authAttributes());
  params.addAll(givenParams);
  url = addParameters(url, params);
  final rawResponse = await http.get(url);
  if (rawResponse.statusCode == 200) {
    return Response.fromJson(json.decode(rawResponse.body));
  } else {
    throw Exception('Failed to process request\nUrl: $url');
  }
}

Future<Response> postRequest(String url,
    [Map<String, String> givenBody = const {}, auth = true]) async {
  Map<String, String> body = {};
  if (auth) body.addAll(authAttributes());
  body.addAll(givenBody);
  final rawResponse = await http.post(url, body: body);
  if (rawResponse.statusCode == 200) {
    return Response.fromJson(json.decode(rawResponse.body));
  } else {
    throw Exception('Failed to process request');
  }
}
