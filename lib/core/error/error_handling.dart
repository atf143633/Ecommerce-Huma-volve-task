import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

class ErrorHandling {
  static Failure handle(dynamic exception) {
    if (exception is DioException) {
      return _handleRemoteError(exception);
    }
    if (exception is FormatException || exception is TypeError) {
      return const Failure(failureMessage: 'Invalid data received from server');
    }
    return const Failure(failureMessage: 'Unexpected error');
  }

  static Failure _handleRemoteError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure(failureMessage: 'Request timed out');
      case DioExceptionType.connectionError:
        return const Failure(
          failureMessage: 'Network connection failed. Check your connection.',
        );
      default:
        break;
    }

    final statusCode = exception.response?.statusCode;
    if (statusCode != null) {
      final message = switch (statusCode) {
        401 => 'Unauthorized',
        403 => 'Forbidden',
        404 => 'Not Found',
        422 => 'Invalid request',
        >= 500 => 'Server error ($statusCode)',
        _ => 'Request failed ($statusCode)',
      };
      return Failure(failureMessage: message);
    }

    return const Failure(failureMessage: 'Network request failed');
  }
}
