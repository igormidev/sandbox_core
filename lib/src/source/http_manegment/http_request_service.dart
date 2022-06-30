import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_exceptions.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_interface.dart';
import 'package:synchronized/synchronized.dart' as sync;
import 'http_request_models.dart';

class HttpRequestService extends HttpRequestInterface {
  // This is the implementation to make this class a singleton.
  // The class returned will be always the same instance.
  HttpRequestService._();
  static HttpRequestService? _instance;
  factory HttpRequestService() => _instance ?? HttpRequestService._();

  final Dio _dio = Dio();
  final _lock = sync.Lock();

  @override
  Future<ResponseModel?>
      makeJsonGetRequest<ResponseModel, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required ResponseModel Function(ResponseType) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  }) async {
    return await _manegeRequest(
      typeOfRequest: 'GET',
      path: path,
      config: config,
      fromMapFunc: fromMapFunc,
      data: null,
      errorFromMapFunc: errorFromMapFunc,
      onError: onError,
    );
  }

  @override
  Future<List<ResponseModel>?>
      makeListOfJsonGetRequest<ResponseModel, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required List<ResponseModel> Function(List<ResponseType>) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  }) async {
    return await _manegeRequest(
      typeOfRequest: 'GET',
      path: path,
      config: config,
      fromMapFunc: fromMapFunc,
      data: null,
      errorFromMapFunc: errorFromMapFunc,
      onError: onError,
    );
  }

  @override
  Future<ResponseModel?>
      makeJsonPostRequest<ResponseModel, DataType, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required DataType objectToBePosted,
    required ResponseModel Function(ResponseType) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  }) async {
    return await _manegeRequest(
      typeOfRequest: 'POST',
      path: path,
      config: config,
      fromMapFunc: fromMapFunc,
      data: objectToBePosted,
      errorFromMapFunc: errorFromMapFunc,
      onError: onError,
    );
  }

  Future<R?> _manegeRequest<R, T, E, O>({
    required String typeOfRequest,
    required String path,
    required HttpRequestConfig config,
    required R Function(T) fromMapFunc,
    required O? data,
    required void Function(E?, HttpRequestException) onError,
    required E? Function(Map<String, dynamic>)? errorFromMapFunc,
  }) async {
    return await _lock.synchronized(() async {
      try {
        Response<dynamic> response = await _makeRequest(
          path: path,
          typeOfRequest: typeOfRequest,
          config: config,
          data: data,
        );
        return _castObject<R, T, E>(onError, fromMapFunc, response);
      } on RedirectException catch (redirectError, stackTrace) {
        final detail = _getRequestModel(path: path, body: data, config: config);
        final model = RedirectFailure(redirectError, stackTrace, detail);
        onError(null, model);
      } on DioError catch (dioError, stackTrace) {
        _manegeDioError(onError, errorFromMapFunc, dioError, stackTrace);
      } catch (error, stackTrace) {
        final detail = _getRequestModel(path: path, body: data, config: config);
        onError(null, HttpUnknownErrorFailure(error, stackTrace, detail));
      }
      return null;
    });
  }

  void _manegeDioError<E>(
    void Function(E?, HttpRequestException) onError,
    E? Function(Map<String, dynamic>)? fromMap,
    DioError dioError,
    StackTrace stackTrace,
  ) {
    try {
      E? error = fromMap != null ? fromMap(dioError.response?.data) : null;
      onError(error, _defineHttpTypeError<E>(dioError, null, stackTrace));
    } catch (error, stackTrace) {
      onError(null, _defineHttpTypeError<E>(dioError, error, stackTrace));
    }
  }

  R? _castObject<R, T, E>(void Function(E?, HttpRequestException) onError,
      R? Function(T) fromMapFunc, Response<dynamic> response) {
    try {
      return fromMapFunc(response.data);
    } catch (error, stackTrace) {
      onError(
        null,
        HttpCastingFailure(response, error, stackTrace),
      );
    }
    return null;
  }

  // This method effectively makes the request with the passed configurations.
  Future<Response<dynamic>> _makeRequest({
    required String path,
    required String typeOfRequest,
    required HttpRequestConfig config,
    required Object? data,
  }) async {
    final response = await _dio.request(
      path,
      queryParameters: config.queryParameters,
      data: data,
      options: Options(
        method: typeOfRequest,
        headers: config.header,
        sendTimeout: config.sendTimeout,
        maxRedirects: config.maxRedirects,
        receiveTimeout: config.receiveTimeout,
        followRedirects: config.followRedirects,
      ),
    );
    return response;
  }

  /// This method typifies the error and return a custom exception.
  HttpRequestException _defineHttpTypeError<E>(
    DioError dioError,
    Object? e,
    StackTrace s,
  ) {
    int? errorCode = dioError.response?.statusCode;
    if (errorCode == 400) return HttpBadRequestFailure(dioError, e, s);
    if (errorCode == 401) return HttpUnauthorizedFailure(dioError, e, s);
    if (errorCode == 403) return HttpForbiddenFailure(dioError, e, s);
    if (errorCode == 404) return HttpNotFoundFailure(dioError, e, s);
    final requestModel = generateRequestDetailsFromDioError(dioError);
    return HttpUnknownErrorFailure(e, s, requestModel);
  }
}

RequestModel _getRequestModel({
  required String path,
  required HttpRequestConfig config,
  required dynamic body,
}) {
  return RequestModel(
    path: path,
    header: config.header,
    queryParameters: config.queryParameters,
    bodyOfPostRequest: body,
  );
}
