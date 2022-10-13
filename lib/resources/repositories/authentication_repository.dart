import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:potok/resources/models/token.dart';
import 'package:potok/resources/repositories/repository_base.dart';

class AuthenticationRepository extends RepositoryBase {
  AuthenticationRepository(BuildContext context)
      : super(context, isTokenReceived: false);

  Future<Token> login(String email, String password) async {
    Response response = await this.client.post(
      '/auth/users/login/',
      queryParameters: {'email': email, 'password': password},
    );
    return Token.fromJson(json.decode(response.data));
  }

  Future<Token> register(String email, String password) async {
    Response response = await this.client.post(
      '/auth/users/register/',
      queryParameters: {'email': email, 'password': password},
    );
    return Token.fromJson(json.decode(response.data));
  }

  Future<Token> anonymous() async {
    Response response = await this.client.post(
          '/auth/users/anonymous/',
        );
    return Token.fromJson(response.data);
  }
}
