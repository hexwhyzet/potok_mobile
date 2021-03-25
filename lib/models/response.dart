import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potok/requests/logging.dart';

class Response {
  final int status;
  String detail;
  final jsonContent;

  Response({this.status, this.jsonContent, this.detail});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
      detail: json['detail'],
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

Future<Response> getRequest(
    {String url, Map<String, String> headers = const {}, auth = true}) async {
  Map<String, String> _headers = {};
  _headers.addAll(headers);

  if (auth) _headers.addAll(await getAuthHeaders());

  final rawResponse = await http.get(url, headers: _headers);
  // print(rawResponse.body);
  return Response.fromJson(json.decode(rawResponse.body));
}

Future<Response> postRequest(
    {String url,
    Map<String, String> headers = const {},
    Map<String, String> body = const {},
    auth = true}) async {
  Map<String, String> _headers = {};
  _headers.addAll(headers);

  if (auth) _headers.addAll(await getAuthHeaders());

  Map<String, String> _body = {};
  _body.addAll(body);

  final rawResponse = await http.post(url, headers: _headers, body: _body);
  // print(rawResponse.body);
  return Response.fromJson(json.decode(rawResponse.body));
}
