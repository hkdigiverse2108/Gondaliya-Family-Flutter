class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool success;

  const ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    required this.success,
  });

  factory ApiResponse.success(T data, {int? statusCode, String? message}) {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: message,
      success: true,
    );
  }

  factory ApiResponse.failure(String message, {int? statusCode}) {
    return ApiResponse(
      message: message,
      statusCode: statusCode,
      success: false,
    );
  }
}
