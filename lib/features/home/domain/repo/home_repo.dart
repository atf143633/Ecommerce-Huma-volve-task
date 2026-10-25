import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<HomeCategoryEntites>>> getCategoriesRepo();
  Future<Either<Failure, List<HomeProductEntites>>> getProductsRepo(
    int categoryId, {
    required int limit,
    required int offset,
  });
}
