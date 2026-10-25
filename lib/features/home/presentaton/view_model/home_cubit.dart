import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentaton/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final int _limit = 10;
  int _offset = 0;

  bool loadingMore = false;
  bool hasMore = false;
  int? selectedCategory;

  final List<HomeProductEntites> _products = [];
  bool _isLoadingProducts = false;
  int _productRequestId = 0;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    _products.clear();
    _offset = 0;
    selectedCategory = null;
    hasMore = false;
    loadingMore = false;
    _isLoadingProducts = false;
    _productRequestId++;
    emit(CategoriesLoading());
    final categories = await getCategoriesUseCase.invoke();
    if (isClosed) return;

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

    await getProductCategories(categoryId);
  }

  Future<void> getProductCategories(int id) async {
    final requestId = ++_productRequestId;
    selectedCategory = id;
    _products.clear();
    _offset = 0;
    hasMore = false;
    loadingMore = false;
    _isLoadingProducts = true;
    emit(ProductsLoading());

    try {
      final products = await getProductsUseCase.invoke(
        id,
        limit: _limit,
        offset: _offset,
      );

      if (requestId != _productRequestId || isClosed) return;
      products.fold(
        (failure) {
          emit(ProductsError(failure.failureMessage));
        },
        (products) {
          _products.addAll(products);
          _offset = products.length;
          hasMore = products.length >= _limit;
          emit(ProductsSuccess(List.unmodifiable(_products)));
        },
      );
    } finally {
      if (requestId == _productRequestId) {
        _isLoadingProducts = false;
      }
    }
  }

  Future<void> loadMoreProducts() async {
    final categoryId = selectedCategory;
    if (loadingMore || !hasMore || _isLoadingProducts || categoryId == null) {
      return;
    }

    final requestId = _productRequestId;
    loadingMore = true;
    emit(ProductLoadingMore());
    try {
      final result = await getProductsUseCase.invoke(
        categoryId,
        limit: _limit,
        offset: _offset,
      );

      if (requestId != _productRequestId || isClosed) return;
      result.fold(
        (failure) {
          emit(ProductLoadingError(errorMassege: failure.failureMessage));
        },
        (newProducts) {
          _products.addAll(newProducts);
          _offset += newProducts.length;
          hasMore = newProducts.length >= _limit;
          emit(ProductsSuccess(List.unmodifiable(_products)));
        },
      );
    } finally {
      if (requestId == _productRequestId) {
        loadingMore = false;
      }
    }
  }
}
