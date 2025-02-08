import 'dart:async';

import 'package:chromo_digital/core/constants/app_const.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@LazySingleton()
class AppDatabaseService {
  static const String _db = 'axaaaacb_${AppConst.dbName}';
  final int _version = 1;

  final String restaurants = 'restaurants';
  final String participants = 'participants';
  final String purposes = 'purposes';
  final String receipts = 'receipts';
  final String company = 'company';

  Database? _database;

  bool get isInitialized => _database?.isOpen ?? false;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    Log.i(runtimeType, 'db init');
    try {
      if (_database == null || !_database!.isOpen) {
        _database = await _initDatabase();
      }
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
    }
  }

  Future<Database> _initDatabase() async {
    Log.i(runtimeType, 'Initializing database');

    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, _db);

    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    Log.i(runtimeType, 'Creating tables');

    await db.execute('''
       CREATE TABLE $restaurants(
         id INTEGER PRIMARY KEY,
         name TEXT,
         address TEXT,
         zipCode INTEGER,
         city TEXT,
         created_at TEXT DEFAULT CURRENT_TIMESTAMP,
         updated_at TEXT DEFAULT CURRENT_TIMESTAMP
       )
     ''');

    await db.execute('''
       CREATE TABLE $participants(
         id INTEGER PRIMARY KEY ,
         name TEXT,
         createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
         updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
       )
     ''');

    await db.execute('''
         CREATE TABLE IF NOT EXISTS $purposes(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           value TEXT,
           createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
           updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
         )
       ''');

    await db.execute('''
         CREATE TABLE IF NOT EXISTS $receipts(
           id INTEGER PRIMARY KEY,
           name TEXT,
           filePath TEXT,
           createdAt TEXT DEFAULT CURRENT_TIMESTAMP
         )
       ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS $company(
          id INTEGER PRIMARY KEY,
          name TEXT,
          street TEXT,
          houseNumber TEXT,
          postId TEXT,          
          city TEXT,
          createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
          showOnReceipt INTEGER -- Store boolean as integer (0 or 1)
        )
      ''');

    Log.i(runtimeType, 'Tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      Log.i(runtimeType, 'Upgrading database schema');

      if (oldVersion < newVersion) {
        // write all upgrade queries
      }
    }
  }

  Future<List<Map<String, Object?>>> read(String query) async {
    try {
      List<Map<String, Object?>> data = await _database!.rawQuery(query);
      Log.i(runtimeType, 'Read data: ${data.length}');
      return data;
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      rethrow;
    }
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      int id = await _database!.insert(table, values);
      Log.i(runtimeType, 'Inserted id: $id');
      return id;
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      rethrow;
    }
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      int result = await _database!.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
      );
      return result;
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      rethrow;
    }
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      int result = await _database!.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      return result;
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      rethrow;
    }
  }

  Future<List<int>> batchInsert(String table, List<Map<String, dynamic>> valuesList) async {
    try {
      final Batch batch = _database!.batch();

      for (final values in valuesList) {
        batch.insert(table, values);
      }

      final List<dynamic> results = await batch.commit();

      final List<int> insertedIds = results.map((result) => result as int).toList();

      Log.i(runtimeType, 'Batch insert completed: ${insertedIds.length} rows inserted');
      return insertedIds;
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      rethrow;
    }
  }
}
