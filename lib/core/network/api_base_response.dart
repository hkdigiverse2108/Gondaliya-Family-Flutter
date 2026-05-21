/// Represents the standard server envelope:
///
/// ```json
/// {
///   "status":  200,
///   "message": "Login successful",
///   "data":    { … },
///   "error":   {}
/// }
/// ```
///
/// Every API call is first parsed into this model.
/// [DioApiService] then passes [data] to the model-specific [fromJson]
/// callback to produce the final typed [ApiResponse<T>].
class ApiBaseResponse {
  /// HTTP-level status code echoed by the server body (e.g. 200, 400, 401).
  final int? status;

  /// Human-readable message from the server.
  final String? message;

  /// Raw payload — will be decoded into a domain model by the caller.
  final dynamic data;

  /// Error details returned by the server (may be a Map or a String).
  final dynamic error;

  const ApiBaseResponse({this.status, this.message, this.data, this.error});

  /// Parses the raw JSON map that Dio gives us as [response.data].
  factory ApiBaseResponse.fromJson(Map<String, dynamic> json) {
    return ApiBaseResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'],
      error: json['error'],
    );
  }

  /// True when the status is in the 2xx range.
  bool get isSuccess {
    if (status == null) return false;
    return status! >= 200 && status! < 300;
  }

  /// Returns the best error string available:
  /// prefers a non-empty [message], then digs into [error].
  String get errorMessage {
    if (message != null && message!.trim().isNotEmpty) return message!;
    if (error != null) {
      if (error is Map) {
        // Some APIs nest the message inside error
        final nested = (error as Map)['message'];
        if (nested != null) return nested.toString();
        // Or return the whole error map stringified
        return error.toString();
      }
      return error.toString();
    }
    return 'An unexpected error occurred.';
  }
}
