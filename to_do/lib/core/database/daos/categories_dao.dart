import 'package:floor/floor.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';

@dao
abstract class CategoryDao {
  /// Observe all categories (used on home screen)
  @Query('SELECT * FROM categories')
  Stream<List<Categories>> observeCategories();

  @insert
  Future<void> addCategory(Categories category);

  @update
  Future<void> updateCategory(Categories category);

  @delete
  Future<void> deleteCategory(Categories category);

  /// Preferred delete by id
  @Query('DELETE FROM categories WHERE id = :id')
  Future<void> deleteCategoryById(String id);

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<Categories?> getCategoryById(String id);

  /// Insert or replace (useful for sync/restore later)
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertCategory(Categories category);

  @insert
  Future<void> insertCategories(List<Categories> categories);

  @Query('DELETE FROM categories')
  Future<void> deleteAllCategories();
}
