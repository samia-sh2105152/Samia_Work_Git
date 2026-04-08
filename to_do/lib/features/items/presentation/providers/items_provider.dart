import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/database/database_providers.dart';
import 'package:to_do/features/items/domain/entities/items.dart';

final itemsByCategoryProvider = StreamProvider.family<List<Items>, String>((
  ref,
  categoryId,
) async* {
  final db = await ref.watch(databaseProvider.future);
  yield* db.itemDao.observeItemsByCategory(categoryId);
});
