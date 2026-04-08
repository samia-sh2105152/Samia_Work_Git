import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/database/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return $FloorAppDatabase.databaseBuilder('yourday.db').build();
});
