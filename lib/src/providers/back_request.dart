import 'package:sandbox_core/src/source/http_manegment/http_request_exceptions.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_interface.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_models.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_service.dart';

class SandHttp {
  static final HttpRequestInterface _request = HttpRequestService();

  static Future<ModelType?>
      makeJsonGetRequest<ModelType, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required ModelType Function(ResponseType) fromMapFunc,
    ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
  }) async {
    final ModelType? response = await _request.makeJsonGetRequest(
      path: path,
      config: config,
      fromMapFunc: fromMapFunc,
      onError: onError,
      errorFromMapFunc: errorFromMapFunc,
    );
    return response;
  }

  static Future<ModelType?> makeJsonPostRequest<ModelType, ResponseType,
      ErrorModel, PostedObjectType>({
    required String path,
    required HttpRequestConfig config,
    required ModelType Function(ResponseType) fromMapFunc,
    ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required PostedObjectType objectToBePosted,
  }) async {
    final ModelType? response = await _request.makeJsonPostRequest(
      path: path,
      config: config,
      fromMapFunc: fromMapFunc,
      onError: onError,
      errorFromMapFunc: errorFromMapFunc,
      objectToBePosted: objectToBePosted,
    );
    return response;
  }

  static Future<List<ModelType>?>
      makeListOfJsonGetRequest<ModelType, ResponseObjectType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required ModelType Function(ResponseObjectType) fromMapFunc,
    ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
  }) async {
    final List<ModelType>? response = await _request
        .makeListOfJsonGetRequest<ModelType, ResponseObjectType, ErrorModel>(
      path: path,
      config: config,
      fromMapFunc: (list) => list.map((e) => fromMapFunc(e)).toList(),
      onError: onError,
      errorFromMapFunc: errorFromMapFunc,
    );
    return response;
  }
}
