import 'package:to_do/features/items/domain/entities/items.dart';

abstract class ItemsRepository {
  /// Live stream for items inside a specific category.
  Stream<List<Items>> observeItemsByCategory(String categoryId);

  Future<Items?> getItemById(String id);

  Future<void> addItem(Items item);

  /// Update title, isDone, etc.
  Future<void> updateItem(Items item);

  Future<void> deleteItemById(String id);

  /// Convenience: toggle completion without rebuilding object in UI.
  Future<void> toggleItemDone({
    required String id,
    required bool isDone,
  });

  /// Optional helper if you ever need a one-shot query (not stream).
  Future<List<Items>> getItemsByCategory(String categoryId);
}
