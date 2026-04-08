// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  ItemsDao? _itemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `items` (`id` TEXT NOT NULL, `categoryId` TEXT NOT NULL, `title` TEXT NOT NULL, `isDone` INTEGER NOT NULL, FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ItemsDao get itemDao {
    return _itemDaoInstance ??= _$ItemsDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _categoriesInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (Categories item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _categoriesUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (Categories item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _categoriesDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (Categories item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Categories> _categoriesInsertionAdapter;

  final UpdateAdapter<Categories> _categoriesUpdateAdapter;

  final DeletionAdapter<Categories> _categoriesDeletionAdapter;

  @override
  Stream<List<Categories>> observeCategories() {
    return _queryAdapter.queryListStream('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) =>
            Categories(id: row['id'] as String, name: row['name'] as String),
        queryableName: 'categories',
        isView: false);
  }

  @override
  Future<void> deleteCategoryById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM categories WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<Categories?> getCategoryById(String id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Categories(id: row['id'] as String, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllCategories() async {
    await _queryAdapter.queryNoReturn('DELETE FROM categories');
  }

  @override
  Future<void> addCategory(Categories category) async {
    await _categoriesInsertionAdapter.insert(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertCategory(Categories category) async {
    await _categoriesInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertCategories(List<Categories> categories) async {
    await _categoriesInsertionAdapter.insertList(
        categories, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(Categories category) async {
    await _categoriesUpdateAdapter.update(category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(Categories category) async {
    await _categoriesDeletionAdapter.delete(category);
  }
}

class _$ItemsDao extends ItemsDao {
  _$ItemsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _itemsInsertionAdapter = InsertionAdapter(
            database,
            'items',
            (Items item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'title': item.title,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener),
        _itemsUpdateAdapter = UpdateAdapter(
            database,
            'items',
            ['id'],
            (Items item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'title': item.title,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener),
        _itemsDeletionAdapter = DeletionAdapter(
            database,
            'items',
            ['id'],
            (Items item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'title': item.title,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Items> _itemsInsertionAdapter;

  final UpdateAdapter<Items> _itemsUpdateAdapter;

  final DeletionAdapter<Items> _itemsDeletionAdapter;

  @override
  Stream<List<Items>> observeItemsByCategory(String categoryId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM items WHERE categoryId = ?1',
        mapper: (Map<String, Object?> row) => Items(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String,
            title: row['title'] as String,
            isDone: (row['isDone'] as int) != 0),
        arguments: [categoryId],
        queryableName: 'items',
        isView: false);
  }

  @override
  Future<void> deleteItemById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM items WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<Items?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Items(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String,
            title: row['title'] as String,
            isDone: (row['isDone'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> toggleItemDone(
    String id,
    int isDoneInt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE items SET isDoneInt = ?2 WHERE id = ?1',
        arguments: [id, isDoneInt]);
  }

  @override
  Future<void> deleteItemsByCategory(String categoryId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM items WHERE categoryId = ?1',
        arguments: [categoryId]);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM items');
  }

  @override
  Future<List<Items>> getItemsByCategory(String categoryId) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE categoryId = ?1',
        mapper: (Map<String, Object?> row) => Items(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String,
            title: row['title'] as String,
            isDone: (row['isDone'] as int) != 0),
        arguments: [categoryId]);
  }

  @override
  Future<void> addItem(Items item) async {
    await _itemsInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertItem(Items item) async {
    await _itemsInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<Items> items) async {
    await _itemsInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Items item) async {
    await _itemsUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Items item) async {
    await _itemsDeletionAdapter.delete(item);
  }
}
