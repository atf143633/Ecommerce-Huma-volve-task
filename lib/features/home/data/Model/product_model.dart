import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/Model/home_model.dart';

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
    final category = json['category'];
    if (category is! Map<String, dynamic>) {
      throw const FormatException('Expected "category" to be an object.');
    }

    final price = json['price'];
    if (price is! num) {
      throw const FormatException('Expected "price" to be a number.');
    }

    final images = json['images'];
    if (images is! List || images.any((image) => image is! String)) {
      throw const FormatException('"images" must be a list of strings.');
    }

    return HomeProductModel(
      id: _requiredInt(json, 'id'),
      title: _requiredString(json, 'title'),
      slug: _requiredString(json, 'slug'),
      price: price.toDouble(),
      description: _requiredString(json, 'description'),
      category: HomeModel.fromJson(category),
      images: List<String>.unmodifiable(images.cast<String>()),
    );
  }
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('Expected "$key" to be an integer.');
  }
  return value;
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('Expected "$key" to be a string.');
  }
  return value;
}
