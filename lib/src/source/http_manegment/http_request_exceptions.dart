import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_models.dart';

abstract class HttpRequestException {
  abstract final String message;
  final int? code;
  final Object? error;
  final StackTrace stackTrace;
  final RequestModel requestDetails;
  HttpRequestException({
    required this.code,
    required this.error,
    required this.stackTrace,
    required this.requestDetails,
  });
}

// 400
class HttpBadRequestFailure extends HttpRequestException {
  @override
  final String message =
      'A bad request to the server happened when trying to get the content.';
  HttpBadRequestFailure(DioError dioError, Object? error, StackTrace stackTrace)
      : super(
          code: dioError.response?.statusCode,
          error: error,
          stackTrace: stackTrace,
          requestDetails: generateRequestDetailsFromDioError(dioError),
        );
}

// 401
class HttpUnauthorizedFailure extends HttpRequestException {
  @override
  final String message = 'You are not authorized to see this content.';
  HttpUnauthorizedFailure(
      DioError dioError, Object? error, StackTrace stackTrace)
      : super(
          code: dioError.response?.statusCode,
          error: error,
          stackTrace: stackTrace,
          requestDetails: generateRequestDetailsFromDioError(dioError),
        );
}

// 403
class HttpForbiddenFailure extends HttpRequestException {
  @override
  final String message = 'The server cannot process what was requested.';
  HttpForbiddenFailure(DioError dioError, Object? error, StackTrace stackTrace)
      : super(
          code: dioError.response?.statusCode,
          error: error,
          stackTrace: stackTrace,
          requestDetails: generateRequestDetailsFromDioError(dioError),
        );
}

// 404
class HttpNotFoundFailure extends HttpRequestException {
  @override
  final String message = 'The content was not found.';
  HttpNotFoundFailure(DioError dioError, Object? error, StackTrace stackTrace)
      : super(
          code: dioError.response?.statusCode,
          error: error,
          stackTrace: stackTrace,
          requestDetails: generateRequestDetailsFromDioError(dioError),
        );
}

/// This exception happends when you had successfully make the request and
/// obtainded a object but, then, `when you are trying to cast the [ Map<String, dynamic> ]
/// from the server to your object`, a error occurs.
/// A tipical exemple is when in your class you are expecting a int in some atribute,
/// but instead you get a double and the whole thing crashes.
class HttpCastingFailure extends HttpRequestException {
  @override
  final String message =
      'An error occurred while trying to convert data from the server.';
  HttpCastingFailure(
    Response<dynamic> reponse,
    Object? error,
    StackTrace stackTrace,
  ) : super(
          code: reponse.statusCode,
          error: error,
          stackTrace: stackTrace,
          requestDetails: _generateRequestDetailsFromResponse(reponse),
        );
}

class HttpUnknownErrorFailure extends HttpRequestException {
  @override
  final String message =
      'A unknown error has occoured while trying to access the server.';
  HttpUnknownErrorFailure(
    Object? error,
    StackTrace stackTrace,
    RequestModel requestModel,
  ) : super(
          code: null,
          error: error,
          stackTrace: stackTrace,
          requestDetails: requestModel,
        );
}

class RedirectFailure extends HttpRequestException {
  @override
  final String message =
      'A error has occoured while trying to redirect the user.';
  RedirectFailure(
    RedirectException? redirectException,
    StackTrace stackTrace,
    RequestModel requestModel,
  ) : super(
          code: null,
          error: redirectException,
          stackTrace: stackTrace,
          requestDetails: requestModel,
        );
}

RequestModel generateRequestDetailsFromDioError(DioError dioError) {
  return RequestModel(
    path: dioError.requestOptions.path,
    header: dioError.requestOptions.headers,
    queryParameters: dioError.requestOptions.queryParameters,
    bodyOfPostRequest: dioError.requestOptions.data,
  );
}

RequestModel _generateRequestDetailsFromResponse(Response<dynamic> response) {
  return RequestModel(
    path: response.requestOptions.path,
    header: response.requestOptions.headers,
    queryParameters: response.requestOptions.queryParameters,
    bodyOfPostRequest: response.requestOptions.data,
  );
}
