import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  Dio dio;
  ApiClient() : dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl)) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          // Don't print requests with URIs containing '/posts'.
          if (options.path.contains('/posts')) {
            return false;
          }
          // Don't print responses with Uint8List data.
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
  }
}
