
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';

class HomeProductModel extends HomeProductEntites {
  HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'],
      description: json['description'],
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
