import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

class ErrorHandling {
  static Failure handle(dynamic exception) {
    // if (exception is FirebaseException) {
    //   return _handleFirebaseError(exception);
    // }

    if (exception is DioException) {
      return _handleRemoteError(exception.toString());
    }
    // if (exception is localException) {
    //   return Failure(failureMessage: exception.errormessage);
    // }
    return Failure(failureMessage: 'un Expected Error');
  }

  static Failure _handleRemoteError(String message) {
    final errorMessage = message.trim();

    if (errorMessage.contains('401') ||
        errorMessage.contains('Unauthorized') ||
        errorMessage.contains('Unauthenticated')) {
      return const Failure(failureMessage: "Unauthorized");
    }
    ;
    if (errorMessage.contains('403') || errorMessage.contains('Forbidden')) {
      return const Failure(failureMessage: "Forbidden");
    }
    if (errorMessage.contains('404') || errorMessage.contains('Not Found')) {
      return const Failure(failureMessage: "Not Found");
    }
    if (errorMessage.contains('422') ||
        errorMessage.contains('Unprocessable Contebt')) {
      return const Failure(failureMessage: "Unprocessable Contebt");
    }
    if (errorMessage.contains('500') ||
        errorMessage.contains('Internal Server Error')) {
      return const Failure(failureMessage: "Internal Server Error");
    }
    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('Connection failed') ||
        errorMessage.contains('HandshakeException')) {
      return const Failure(failureMessage: "SocketException");
    }
    if (errorMessage.contains('Timeout') || errorMessage.contains('Deadline')) {
      return const Failure(failureMessage: 'Deadline');
    }
    if (errorMessage.contains('TypeError') ||
        errorMessage.contains('FormatException')) {
      return const Failure(failureMessage: "FormatException");
    }
    if (errorMessage.isEmpty &&
        errorMessage.contains('Eception') &&
        errorMessage.contains('Error')) {
      return Failure(failureMessage: 'Error');
    }
    return const Failure(failureMessage: "Eception");
  }
}

// static Failure _handleFirebaseErrorndle(FirebaseException exception) {
//   switch (exception.code) {
//     case 'invalid-credential':
//       return const Failure(failureMessage: AppStrings.ivalidLoginCerdentials);
//     case 'user-not-found':
//       return const Failure(failureMessage: AppStrings.accountNotFound);
//     case 'invalid-email':
//       return const Failure(failureMessage: AppStrings.ivalidEmailFormat);
//     case 'user-disabeld':
//       return const Failure(failureMessage: AppStrings.accountDisabled);

//       // الاخطاء العامه
//       case 'permission-denied' :
//       return const Failure(failureMessage: AppString.unauthorized);
//       case 'unavailable' :
//       return const Failure(failureMessage: AppString.noServerConnection);
//       case 'not-found' :
//       return const Failure(failureMessage: AppString.dataNotFound);
//       case 'deadline-exceeded' :
//       return const Failure(failureMessage: AppString.connectionTimeout);

//       default:
//         return Failure(exception.message ?? AppString.databaseConnectionError);
//   }

//}
