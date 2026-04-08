import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class Categories {
  @primaryKey
  final String id;
  final String name;

  const Categories({required this.id, required this.name});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(id: json["id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }

  Categories copyWith({String? id, String? name}) {
    return Categories(id: id ?? this.id, name: name ?? this.name);
  }
}
