// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:to_do/core/database/daos/categories_dao.dart';
import 'package:to_do/core/database/daos/items_dao.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';
import 'package:to_do/features/items/domain/entities/items.dart';
part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Categories, Items])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  ItemsDao get itemDao;
}
