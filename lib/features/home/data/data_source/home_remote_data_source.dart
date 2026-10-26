import 'package:ecommerce_app_huma_volve/features/home/data/Model/home_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/Model/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeModel>> getCategories();
  Future<HomeProductModel> getProductById(int productId);
  Future<List<HomeProductModel>> getProducts(
    int categoryId, {
    required int limit,
    required int offset,
  });
}
