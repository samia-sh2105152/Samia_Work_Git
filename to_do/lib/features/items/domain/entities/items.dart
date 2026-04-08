import 'package:floor/floor.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';

@Entity(
  tableName: 'items',
  foreignKeys: [
    ForeignKey(
      childColumns: ['categoryId'],
      parentColumns: ['id'],
      entity: Categories,
    ),
  ],
)
class Items {
  @primaryKey
  final String id;
  final String categoryId;
  final String title;
  final bool isDone;

  const Items({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.isDone,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json["id"],
      categoryId: json["categoryId"],
      title: json["title"],
      isDone: json["isDone"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categoryId": categoryId,
      "title": title,
      "isDone": isDone,
    };
  }

  Items copyWith({
    String? id,
    String? categoryId,
    String? title,
    bool? isDone,
  }) {
    return Items(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
