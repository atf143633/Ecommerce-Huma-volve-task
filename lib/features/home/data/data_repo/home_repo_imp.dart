import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepoImp(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<HomeCategoryEntites>>> getCategoriesRepo() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories as List<HomeCategoryEntites>);
    } catch (e) {
      return Left(ErrorHandling.handle(e));
    }
  }

  @override
  Future<Either<Failure, HomeProductEntites>> getProductByIdRepo(
    int productId,
  ) async {
    try {
      final product = await homeRemoteDataSource.getProductById(productId);
      return Right(product);
    } catch (e) {
      return Left(ErrorHandling.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductEntites>>> getProductsRepo(
    int categoryId, {
    required int limit,
    required int offset,
  }) async {
    try {
      final products = await homeRemoteDataSource.getProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );
      return Right(products);
    } catch (e) {
      return Left(ErrorHandling.handle(e));
    }
  }
}
