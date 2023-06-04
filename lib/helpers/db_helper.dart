import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'persons.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE persons(id TEXT PRIMARY KEY, first_name TEXT, last_name TEXT, gender TEXT, dob DATE, image TEXT)');
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> update(
    String table,
    Map<String, Object> data,
    String id,
  ) async {
    final db = await DBHelper.database();
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(
      String table, String columnName, String value) async {
    final db = await DBHelper.database();
    await db.delete(table, where: '$columnName = ?', whereArgs: [value]);
  }
}
