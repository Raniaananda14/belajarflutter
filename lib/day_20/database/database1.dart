import 'dart:developer';

import 'package:flutter_application_1/day_20/models/model1.dart';
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
      // onUpgrade: (db, oldVersion, newVersion) {
      //    await db.execute('''
      //     CREATE TABLE users(
      //       id INTEGER PRIMARY KEY AUTOINCREMENT,
      //       email TEXT UNIQUE,
      //       password TEXT
      //     )
      //   ''');
      // },
    );
  }

  // Fungsi Register CREATE
  Future<bool> registerUser(UserModelBizgrow pengguna) async {
    final db = await database;
    try {
      await db.insert('users', pengguna.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Fungsi Login GET
  Future<UserLoginModels?> loginUser(UserLoginModels pengguna) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [pengguna.email, pengguna.password],
    );
    log(results.toString());

    if (results.isNotEmpty) {
      return UserLoginModels.fromMap(results.first);
    }
    return null;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<UserModelBizgrow>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('users');

    return results.map((map) => UserModelBizgrow.fromMap(map)).toList();
  }

  // Fungsi untuk menghapus user berdasarkan ID
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk memperbarui data user
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
      return false;
    }
  }
}
