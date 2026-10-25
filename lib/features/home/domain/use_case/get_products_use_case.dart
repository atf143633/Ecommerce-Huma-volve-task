import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/home_repo.dart';

class GetProductsUseCase {
  final HomeRepo homeRepo;

  GetProductsUseCase(this.homeRepo);

  Future<Either<Failure, List<HomeProductEntites>>> invoke(
    int categoryId, {
    required int limit,
    required int offset,
  }) {
    return homeRepo.getProductsRepo(categoryId, limit: limit, offset: offset);
  }
}
