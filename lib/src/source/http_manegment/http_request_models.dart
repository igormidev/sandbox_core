/// Http request configurations.
class HttpRequestConfig {
  /// Http request headers. The keys of initial headers will be converted
  /// to lowercase, for example 'Content-Type' will be converted to 'content-type'.
  Map<String, dynamic>? header;

  /// Http request query parameters that will be in the url.
  Map<String, dynamic>? queryParameters;

  // TODO: CRIAR EXCEPTION DE TIMEOUT sendTimeout E receiveTimeout

  /// Timeout in milliseconds for sending data.
  /// [Dio] will throw the [DioError] with [DioErrorType.sendTimeout] type
  ///  when time out.
  int? sendTimeout;

  ///  Timeout in milliseconds for receiving data.
  ///
  ///  Note: [receiveTimeout]  represents a timeout during data transfer! That is to say the
  ///  client has connected to the server, and the server starts to send data to the client.
  ///
  /// [0] meanings no timeout limit.
  int? receiveTimeout;

  /// Will follow the redirects of the url [maxRedirects] times.
  bool? followRedirects;

  // TODO: CRIAR EXCEPTION DE followRedirects

  /// Set this property to the maximum number of redirects to follow
  /// when [followRedirects] is `true`. If this number is exceeded
  /// an error event will be added with a [RedirectException].
  ///
  /// The default value is 5.
  int? maxRedirects;

  HttpRequestConfig({
    this.header,
    this.queryParameters,
    this.sendTimeout,
    this.receiveTimeout,
    this.followRedirects,
    this.maxRedirects,
  });
}

class RequestModel {
  final String path;
  final Map<String, dynamic>? header;
  final Map<String, dynamic>? queryParameters;
  final dynamic bodyOfPostRequest;
  const RequestModel({
    required this.path,
    required this.header,
    required this.queryParameters,
    required this.bodyOfPostRequest,
  });
}
