import 'package:ecommerce_app_huma_volve/features/home/services/Model/home_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/Model/product_model.dart';

abstract class HomeState {
  HomeState();
}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoiresSuccess extends HomeState {
  final List<HomeModel> categories;

  CategoiresSuccess(this.categories);
}

class CategoiresError extends HomeState {
  final String errorMassege;

  CategoiresError(this.errorMassege);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<ProductModel> products;

  ProductsSuccess(this.products);
}

class ProductsError extends HomeState {
  final String errorMassege;

  ProductsError(this.errorMassege);
}
