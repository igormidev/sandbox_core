import 'package:sandbox_core/src/source/http_manegment/http_request_models.dart';
import 'http_request_exceptions.dart';

/// [ HttpRequestInterface ] is the interface with the contract of what the
/// class that is gonna make the Dependency Injection has to have.
abstract class HttpRequestInterface {
  Future<ResponseModel?>
      makeJsonGetRequest<ResponseModel, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required ResponseModel Function(ResponseType) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  });

  Future<List<ResponseModel>?>
      makeListOfJsonGetRequest<ResponseModel, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required List<ResponseModel> Function(List<ResponseType>) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  });

  Future<ResponseModel?>
      makeJsonPostRequest<ResponseModel, DataType, ResponseType, ErrorModel>({
    required String path,
    required HttpRequestConfig config,
    required DataType objectToBePosted,
    required ResponseModel Function(ResponseType) fromMapFunc,
    required void Function(ErrorModel?, HttpRequestException) onError,
    required ErrorModel? Function(Map<String, dynamic>)? errorFromMapFunc,
  });
}
