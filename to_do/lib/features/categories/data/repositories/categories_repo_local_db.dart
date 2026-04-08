import 'package:to_do/core/database/daos/categories_dao.dart';
import 'package:to_do/features/categories/domain/contracts/categories_repository.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';

/// Repository implementation that loads categories from local database
class CategoriesRepoLocalDB implements CategoriesRepository {
  final CategoryDao _categoryDao;
  CategoriesRepoLocalDB(this._categoryDao);

  @override
  Stream<List<Categories>> observeCategories() {
    return _categoryDao.observeCategories();
  }

  @override
  Future<Categories?> getCategoryById(String id) {
    return _categoryDao.getCategoryById(id);
  }

  @override
  Future<void> addCategory(Categories category) {
    return _categoryDao.addCategory(category);
  }

  @override
  Future<void> updateCategory(Categories category) {
    return _categoryDao.updateCategory(category);
  }

  @override
  Future<void> deleteCategoryById(String id) {
    return _categoryDao.deleteCategoryById(id);
  }
}
