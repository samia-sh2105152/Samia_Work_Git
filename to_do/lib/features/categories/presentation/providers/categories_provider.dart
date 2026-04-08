import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/database/daos/categories_dao.dart';
import 'package:to_do/core/database/database_providers.dart';
import 'package:to_do/features/categories/data/repositories/categories_repo_local_db.dart';
import 'package:to_do/features/categories/domain/contracts/categories_repository.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final dbAsync = ref.watch(databaseProvider);

  // simplest safe way
  return dbAsync.requireValue.categoryDao;
});

final categoriesRepoProvider = Provider<CategoriesRepository>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoriesRepoLocalDB(dao);
});
final categoriesStreamProvider =
    StreamProvider<List<Categories>>((ref) {
  final repo = ref.watch(categoriesRepoProvider);
  return repo.observeCategories();
});

