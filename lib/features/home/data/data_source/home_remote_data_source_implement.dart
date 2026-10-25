import 'package:ecommerce_app_huma_volve/core/constant/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/Model/home_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/Model/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';

class HomeRemoteDataSourceImplement implements HomeRemoteDataSource {
  final ApiClient apiClient;
  HomeRemoteDataSourceImplement({required this.apiClient});
  @override
  Future<List<HomeModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoint.categoriesEndpoint);
    final List jsonData = response.data;
    final List<HomeModel> categories = jsonData
        .map((e) => HomeModel.fromJson(e))
        .toList();
    return categories;
  }

  @override
  Future<List<HomeProductModel>> getProducts(int? categoryId) async {
    final response = await apiClient.dio.get(
      "${ApiEndpoint.categoriesEndpoint}/$categoryId/${ApiEndpoint.productsEndpoint}",
    );
    final List jsonData = response.data;
    final List<HomeProductModel> products = jsonData
        .map((e) => HomeProductModel.fromJson(e))
        .toList();

    return products;
  }
}
