import 'dart:developer';
import 'package:flutter_application_1/day_22/models/models.dart';
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
    final path = join(dbPath, 'bizgrow_day22.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Users Table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            nik TEXT
          )
        ''');

        // Products Table
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            harga REAL,
            stok INTEGER,
            deskripsi TEXT,
            kategori TEXT,
            status TEXT
          )
        ''');

        // Targets Table
        await db.execute('''
          CREATE TABLE targets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bulan TEXT,
            targetJumlah REAL,
            tercapaiJumlah REAL,
            status TEXT
          )
        ''');

        // Activities Table
        await db.execute('''
          CREATE TABLE activities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kodePesanan TEXT,
            tanggal TEXT,
            total REAL,
            status TEXT
          )
        ''');

        // Seed initial data
        await _seedInitialData(db);
      },
    );
  }

  Future<void> _seedInitialData(Database db) async {
    // Seed standard admin user
    await db.insert('users', {
      'email': 'admin@example.com',
      'password': 'password123',
      'nik': '1234567890123456'
    });

    // Seed products
    final products = [
      {
        'nama': 'Produk A',
        'harga': 150000.0,
        'stok': 25,
        'deskripsi': 'Handcrafted ceramic vase featuring minimalist design and clean natural texture.',
        'kategori': 'Elektronik',
        'status': 'Aktif'
      },
      {
        'nama': 'Produk B',
        'harga': 200000.0,
        'stok': 40,
        'deskripsi': 'Handwoven bamboo tote bag. Lightweight, organic, and elegant.',
        'kategori': 'Pakaian',
        'status': 'Aktif'
      },
      {
        'nama': 'Produk C',
        'harga': 75000.0,
        'stok': 0,
        'deskripsi': 'Traditional handwritten batik scarf, colored with organic Javanese indigo.',
        'kategori': 'Pakaian',
        'status': 'Habis'
      },
      {
        'nama': 'Produk D',
        'harga': 120000.0,
        'stok': 18,
        'deskripsi': 'Reclaimed Javanese teak root bowl, ideal for statement centerpieces.',
        'kategori': 'Makanan',
        'status': 'Aktif'
      }
    ];

    for (var prod in products) {
      await db.insert('products', prod);
    }

    // Seed targets
    final targets = [
      {
        'bulan': 'Juni 2024',
        'targetJumlah': 30000000.0,
        'tercapaiJumlah': 15000000.0,
        'status': 'Belum Tercapai'
      },
      {
        'bulan': 'Juli 2024',
        'targetJumlah': 28000000.0,
        'tercapaiJumlah': 28000000.0,
        'status': 'Tercapai'
      },
      {
        'bulan': 'Agustus 2024',
        'targetJumlah': 35000000.0,
        'tercapaiJumlah': 10000000.0,
        'status': 'Belum Tercapai'
      }
    ];

    for (var target in targets) {
      await db.insert('targets', target);
    }

    // Seed activities
    final activities = [
      {
        'kodePesanan': '#BIZ-1001',
        'tanggal': '12 Mei 2024',
        'total': 250000.0,
        'status': 'Selesai'
      },
      {
        'kodePesanan': '#BIZ-1002',
        'tanggal': '13 Mei 2024',
        'total': 450000.0,
        'status': 'Selesai'
      },
      {
        'kodePesanan': '#BIZ-1003',
        'tanggal': '14 Mei 2024',
        'total': 150000.0,
        'status': 'Pending'
      }
    ];

    for (var act in activities) {
      await db.insert('activities', act);
    }
  }

  // User Auth
  Future<bool> registerUser(UserModelBizgrow user) async {
    final db = await database;
    try {
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      log("Error registering user: $e");
      return false;
    }
  }

  Future<UserModelBizgrow?> loginUser(String email, String password) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (res.isNotEmpty) {
        return UserModelBizgrow.fromMap(res.first);
      }
    } catch (e) {
      log("Error logging in: $e");
    }
    return null;
  }

  // Products CRUD
  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query('products');
      return res.map((m) => ProductModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting products: $e");
      return [];
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    final db = await database;
    try {
      await db.insert('products', product.toMap());
      return true;
    } catch (e) {
      log("Error adding product: $e");
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    final db = await database;
    try {
      int count = await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      return count > 0;
    } catch (e) {
      log("Error updating product: $e");
      return false;
    }
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    try {
      await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log("Error deleting product: $e");
    }
  }

  // Targets CRUD
  Future<List<TargetModel>> getAllTargets() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query('targets');
      return res.map((m) => TargetModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting targets: $e");
      return [];
    }
  }

  Future<bool> addTarget(TargetModel target) async {
    final db = await database;
    try {
      await db.insert('targets', target.toMap());
      return true;
    } catch (e) {
      log("Error adding target: $e");
      return false;
    }
  }

  // Activities CRUD
  Future<List<ActivityModel>> getAllActivities() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query('activities');
      return res.map((m) => ActivityModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting activities: $e");
      return [];
    }
  }
}
