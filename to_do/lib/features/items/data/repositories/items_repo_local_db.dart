import 'package:to_do/core/database/daos/items_dao.dart';
import 'package:to_do/features/items/domain/contracts/items_repository.dart';
import 'package:to_do/features/items/domain/entities/items.dart';

/// Repository implementation that loads todo items from local database
class ItemsRepoLocalDB implements ItemsRepository {
  final ItemsDao _todoItemDao;

  ItemsRepoLocalDB(this._todoItemDao);

  @override
  Stream<List<Items>> observeItemsByCategory(String categoryId) {
    return _todoItemDao.observeItemsByCategory(categoryId);
  }

  @override
  Future<Items?> getItemById(String id) {
    return _todoItemDao.getItemById(id);
  }

  @override
  Future<void> addItem(Items item) {
    return _todoItemDao.addItem(item);
  }

  @override
  Future<void> updateItem(Items item) {
    return _todoItemDao.updateItem(item);
  }

  @override
  Future<void> deleteItemById(String id) {
    return _todoItemDao.deleteItemById(id);
  }

  @override
  Future<void> toggleItemDone({
    required String id,
    required bool isDone,
  }) {
    final int isDoneInt = isDone ? 1 : 0;
    return _todoItemDao.toggleItemDone(id, isDoneInt);
  }

  @override
  Future<List<Items>> getItemsByCategory(String categoryId) {
    return _todoItemDao.getItemsByCategory(categoryId);
  }
}
