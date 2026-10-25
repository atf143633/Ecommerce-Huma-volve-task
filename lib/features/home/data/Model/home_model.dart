import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';

class HomeModel extends HomeCategoryEntites {
  HomeModel({required super.id, required super.name});

  HomeModel.fromJson(Map<String, dynamic> json)
    : super(id: json['id'], name: json['name']);
}
