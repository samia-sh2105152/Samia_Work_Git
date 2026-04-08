import 'package:to_do/features/categories/domain/entities/categories.dart';

abstract class CategoriesRepository {
  /// Live stream for home screen (categories list).
  Stream<List<Categories>> observeCategories();

  /// One-time read (useful for detail screens or edit flows).
  Future<Categories?> getCategoryById(String id);

  Future<void> addCategory(Categories category);

  /// Rename / edit.
  Future<void> updateCategory(Categories category);

  /// Delete category by id (preferred).
  Future<void> deleteCategoryById(String id);
}
