import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/configs/configs.dart';
import 'package:potok/resources/models/token.dart';
import 'package:potok/resources/repositories/token_repository.dart';
import 'package:potok/screens/authentication/token_bloc.dart';
import 'package:potok/screens/authentication/token_event.dart';
import 'package:potok/screens/authentication/token_state.dart';

class HttpManager {
  var dio = Dio();
  final tokenRepository = TokenRepository();
  final isTokenReceived;

  HttpManager(BuildContext context, this.isTokenReceived) {
    dio.options.baseUrl = mainServerUrl;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          // log('Request to $mainServerUrl${options.path}');
          if (this.isTokenReceived) {
            // log('- request marked as isTokenReceived true');
            TokenBloc bloc = context.read<TokenBloc>();
            if (bloc.state is TokenReceived) {
              // log('- TokenBloc has state TokenReceived');
              options.headers.addAll({
                "Authorization":
                    "Bearer ${(bloc.state as TokenReceived).token.token}",
                Headers.contentTypeHeader: Headers.jsonContentType,
              });
            } else {
              // log('- TokenBloc has state TokenNotReceived');
            }
          } else {
            // log('- request marked as unauthenticated');
          }
          return handler.next(options);
        },
        onError: (DioError error, ErrorInterceptorHandler handler) {
          log(error.message);
          if (error.response!.statusCode == 401) {
            if (this.isTokenReceived) {
              TokenBloc bloc = context.read<TokenBloc>();
              if (bloc.state is TokenReceived) {
                bloc.add(Logout());
                // log('- current token is not valid, logging out');
              } else {
                // log('- this method requires token');
              }
            }
          }
          log(error.toString());
        },
      ),
    );
  }
}

class RepositoryBase {
  RepositoryBase(BuildContext context, {bool isTokenReceived = true}) {
    _httpManager = HttpManager(context, isTokenReceived);
  }

  late HttpManager _httpManager;

  Dio get client => _httpManager.dio;
}
