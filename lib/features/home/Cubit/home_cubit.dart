import 'package:ecommerce_app_huma_volve/features/home/Cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices homeServices;

  HomeCubit(this.homeServices) : super(CategoriesLoading());

  void loadHomeData() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeServices.getCategories();
      emit(CategoiresSuccess(categories));
      final products = await homeServices.getProducts(categories[0].id);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(CategoiresError(e.toString()));
    }
  }
}
