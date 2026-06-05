import 'dart:developer';
import 'package:flutter_application_1/day_21/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    // Use a separate database file or same (to share/migrate data, but separate is cleaner for day_21 isolates)
    // Let's use 'data_day21.db' or share 'data.db'. Using data.db means it shares database, let's keep data.db so any old accounts are visible!
    final path = join(dbPath, 'data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            nik TEXT
          )
        ''');
      },
    );
  }

  // Register User
  Future<bool> registerUser(UserModelBizgrow pengguna) async {
    final db = await database;
    try {
      await db.insert('users', pengguna.toMap());
      return true;
    } catch (e) {
      log("Register Error: ${e.toString()}");
      return false;
    }
  }

  // Login User
  Future<UserModelBizgrow?> loginUser(UserLoginModels pengguna) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [pengguna.email, pengguna.password],
      );
      if (results.isNotEmpty) {
        return UserModelBizgrow.fromMap(results.first);
      }
    } catch (e) {
      log("Login Error: ${e.toString()}");
    }
    return null;
  }

  // Get All Users
  Future<List<UserModelBizgrow>> getAllUsers() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> results = await db.query('users');
      return results.map((map) => UserModelBizgrow.fromMap(map)).toList();
    } catch (e) {
      log("Get All Users Error: ${e.toString()}");
      return [];
    }
  }

  // Delete User
  Future<void> deleteUser(int id) async {
    final db = await database;
    try {
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log("Delete User Error: ${e.toString()}");
    }
  }

  // Update User
  Future<bool> updateUser(UserModelBizgrow pengguna) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        pengguna.toMap(),
        where: 'id = ?',
        whereArgs: [pengguna.id],
      );
      return count > 0;
    } catch (e) {
      log("Update User Error: ${e.toString()}");
      return false;
    }
  }
}
