class HomeModel {
  int? id;
  String? name;

  HomeModel({this.id, this.name});

  HomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
