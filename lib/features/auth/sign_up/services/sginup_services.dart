import 'package:ecommerce_app_huma_volve/core/constant/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/Models/signup_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/Models/signup_parametar_model.dart';

class SginupServices {
  late final ApiClient apiClient;
  SginupServices(this.apiClient);
  Future<SignupModel> signUp(SignupParametarModel signupParametarModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoint.signEndpoint,
      data: {
        "email": signupParametarModel.email,
        "name": signupParametarModel.name,
        "password": signupParametarModel.password,
        "avatar": "https://api.escuelajs.co/api/v1/files/avatar.jpg",
      },
    );
    final jsonData = response.data;
    final dartData = SignupModel.fromJson(jsonData);
    return dartData;
  }
}
