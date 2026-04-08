import 'package:floor/floor.dart';
import 'package:to_do/features/items/domain/entities/items.dart';
@dao
abstract class ItemsDao {
  /// Observe items for a given category (used in category detail screen)
  @Query('SELECT * FROM items WHERE categoryId = :categoryId')
  Stream<List<Items>> observeItemsByCategory(String categoryId);

  @insert
  Future<void> addItem(Items item);

  @update
  Future<void> updateItem(Items item);

  @delete
  Future<void> deleteItem(Items item);

  @Query('DELETE FROM items WHERE id = :id')
  Future<void> deleteItemById(String id);

  @Query('SELECT * FROM items WHERE id = :id')
  Future<Items?> getItemById(String id);

  /// Toggle done/undone without loading full object
  @Query('UPDATE items SET isDoneInt = :isDoneInt WHERE id = :id')
  Future<void> toggleItemDone(String id, int isDoneInt);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertItem(Items item);

  @insert
  Future<void> insertItems(List<Items> items);

  @Query('DELETE FROM items WHERE categoryId = :categoryId')
  Future<void> deleteItemsByCategory(String categoryId);

  @Query('DELETE FROM items')
  Future<void> deleteAllItems();

  /// One-shot query (non-stream)
  @Query('SELECT * FROM items WHERE categoryId = :categoryId')
  Future<List<Items>> getItemsByCategory(String categoryId);
}
