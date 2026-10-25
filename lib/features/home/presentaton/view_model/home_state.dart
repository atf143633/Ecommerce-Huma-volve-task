
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';

abstract class HomeState {
  HomeState();
}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoiresSuccess extends HomeState {
  final List<HomeCategoryEntites> categories;

  CategoiresSuccess(this.categories);
}

class CategoiresError extends HomeState {
  final String errorMassege;

  CategoiresError(this.errorMassege);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<HomeProductEntites> products;

  ProductsSuccess(this.products);
}

class ProductsError extends HomeState {
  final String errorMassege;

  ProductsError(this.errorMassege);
}
