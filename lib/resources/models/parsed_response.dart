import 'package:dio/dio.dart';

class ParsedResponse<T> extends Response {
  T? content;

  ParsedResponse(Response response, T content)
      : super(
          data: response.data,
          headers: response.headers,
          requestOptions: response.requestOptions,
          isRedirect: response.isRedirect,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          redirects: response.redirects,
          extra: response.extra,
        ) {
    this.content = content;
  }
}
