import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/home_repo.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this.homeRepo);

  final HomeRepo homeRepo;

  Future<Either<Failure, HomeProductEntites>> invoke(int productId) {
    return homeRepo.getProductByIdRepo(productId);
  }
}
