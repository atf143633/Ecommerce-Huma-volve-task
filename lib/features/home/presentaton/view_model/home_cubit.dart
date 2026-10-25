import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentaton/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoriesLoading());
    final categories = await getCategoriesUseCase.invoke();
    final categoryId = categories.fold<int?>(
      (failure) {
        emit(CategoiresError(failure.failureMessage));
        return null;
      },
      (categories) {
        emit(CategoiresSuccess(categories));
        return categories.isEmpty ? null : categories.first.id;
      },
    );

    if (categoryId == null) {
      if (state is CategoiresSuccess) {
        emit(ProductsSuccess(const []));
      }
      return;
    }

    emit(ProductsLoading());
    final products = await getProductsUseCase.invoke(categoryId);
    products.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        emit(ProductsSuccess(products));
      },
    );
  }

  void getProductCategories(int id) async {
    emit(ProductsLoading());

    final products = await getProductsUseCase.invoke(id);
    products.fold(
      (failure) => emit(ProductsError(failure.failureMessage)),
      (products) => emit(ProductsSuccess(products)),
    );
  }
}
