import 'package:ecommerce_app_huma_volve/core/constant/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/Model/login_model.dart';

class LoginServices {
  ApiClient apiClient;
  LoginServices(this.apiClient);
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoint.loginEndpoint,
      data: {"email": email, "password": password},
    );
    final Map<String, dynamic> dataTokens = response.data;
    final modelData = LoginModel.fromJson(dataTokens);
    await SecureStorage.saveAccessToken(modelData.accessToken);
    await SecureStorage.savereFreshToken(modelData.refreshToken);
    return modelData;
  }
}
