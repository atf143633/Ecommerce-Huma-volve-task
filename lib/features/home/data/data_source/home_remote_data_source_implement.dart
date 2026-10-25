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
    return _parseList(response.data, HomeModel.fromJson, 'categories');
  }

  @override
  Future<List<HomeProductModel>> getProducts(
    int categoryId, {
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.dio.get(
      "${ApiEndpoint.categoriesEndpoint}/$categoryId/${ApiEndpoint.productsEndpoint}",
      queryParameters: {"limit": limit, "offset": offset},
    );

    return _parseList(response.data, HomeProductModel.fromJson, 'products');
  }

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
    String resource,
  ) {
    if (data is! List) {
      throw FormatException('Expected the $resource response to be a list.');
    }

    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw FormatException(
              'Expected each item in the $resource response to be an object.',
            );
          }
          return fromJson(item);
        })
        .toList(growable: false);
  }
}
