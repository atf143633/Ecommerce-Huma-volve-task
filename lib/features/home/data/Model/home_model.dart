import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';

class HomeModel extends HomeCategoryEntites {
  HomeModel({required super.id, required super.name});

  HomeModel.fromJson(Map<String, dynamic> json)
    : super(id: _requiredInt(json, 'id'), name: _requiredString(json, 'name'));
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
