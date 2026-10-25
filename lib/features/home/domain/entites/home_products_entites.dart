import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';

class HomeProductEntites {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final HomeCategoryEntites category;
  final List<String> images;

  HomeProductEntites({
    this.id = 0,
    this.title = "",
    this.slug = "",
    this.price = 0,
    this.description = '',
    this.category = const HomeCategoryEntites(),
    this.images = const [''],
  });
}
