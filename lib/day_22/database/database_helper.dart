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
    final path = join(dbPath, 'bizgrow_day22_v12.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Users Table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT UNIQUE,
            password TEXT,
            nik TEXT,
            profileImage TEXT,
            role TEXT,
            securityQuestion TEXT,
            securityAnswer TEXT
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
            status TEXT,
            gambar TEXT,
            toko TEXT
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
            status TEXT,
            alamat TEXT,
            koordinatX REAL,
            koordinatY REAL,
            namaProduk TEXT,
            jumlah INTEGER,
            buyerEmail TEXT
          )
        ''');

        // Cart Table
        await db.execute('''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER,
            buyerEmail TEXT,
            jumlah INTEGER
          )
        ''');

        // Seed initial data
        await _seedInitialData(db);
      },
      onOpen: (db) async {
        // Safe migrations for older DB versions
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN alamat TEXT");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN koordinatX REAL");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN koordinatY REAL");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN namaProduk TEXT");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN jumlah INTEGER");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE users ADD COLUMN role TEXT");
        } catch (_) {}
        try {
          await db.execute(
            "ALTER TABLE users ADD COLUMN securityQuestion TEXT",
          );
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE users ADD COLUMN securityAnswer TEXT");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE activities ADD COLUMN buyerEmail TEXT");
        } catch (_) {}
        try {
          await db.execute("ALTER TABLE products ADD COLUMN toko TEXT");
        } catch (_) {}
        try {
          await db.execute(
            "UPDATE users SET role = 'Owner' WHERE email = 'rania@gmail.com'",
          );
        } catch (_) {}
        try {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS cart(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              productId INTEGER,
              buyerEmail TEXT,
              jumlah INTEGER
            )
          ''');
        } catch (_) {}
        try {
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/6.webp' WHERE nama = 'Produk I'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/7.webp' WHERE nama = 'Produk J'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/11.jpg' WHERE nama = 'Produk K'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/12.jpg' WHERE nama = 'Produk L'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/13.jpg' WHERE nama = 'Produk M'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/14.jpg' WHERE nama = 'Produk N'",
          );
          await db.execute(
            "UPDATE products SET gambar = 'assets/images/15.jpg' WHERE nama = 'Produk O'",
          );
        } catch (_) {}
      },
    );
  }

  Future<void> _seedInitialData(Database db) async {
    // Seed standard admin user matching mockup
    await db.insert('users', {
      'nama': 'Rania Ananda',
      'email': 'rania@gmail.com',
      'password': 'password123',
      'nik': '1234567890123456',
      'profileImage': null,
      'role': 'Owner',
    });

    // Seed products
    final products = [
      {
        'nama': 'Produk A',
        'harga': 150000.0,
        'stok': 35,
        'deskripsi':
            'Handcrafted ceramic vase featuring minimalist design and clean natural texture.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/1.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Produk B',
        'harga': 200000.0,
        'stok': 40,
        'deskripsi':
            'Handwoven bamboo tote bag. Lightweight, organic, and elegant.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/3.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Produk C',
        'harga': 75000.0,
        'stok': 10,
        'deskripsi':
            'Traditional handwritten batik scarf, colored with organic Javanese indigo.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/8.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Produk D',
        'harga': 120000.0,
        'stok': 18,
        'deskripsi':
            'Reclaimed Javanese teak root bowl, ideal for statement centerpieces.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/9.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Produk E (Habis)',
        'harga': 90000.0,
        'stok': 0,
        'deskripsi': 'Modern glass planter box with brass details.',
        'kategori': 'Lainnya',
        'status': 'Tidak Tersedia',
        'gambar': 'assets/images/10.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Produk F',
        'harga': 180000.0,
        'stok': 25,
        'deskripsi':
            'Rustic wooden serving tray made from sustainably sourced mahogany.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/2.webp',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Produk G',
        'harga': 350000.0,
        'stok': 15,
        'deskripsi':
            'Premium ergonomic wireless mouse with multi-device connectivity.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/4.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Produk H',
        'harga': 65000.0,
        'stok': 50,
        'deskripsi':
            'Locally harvested organic flower honey, raw and unfiltered.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/5.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Produk I',
        'harga': 220000.0,
        'stok': 30,
        'deskripsi': 'Casual daily linen shirt, highly breathable and soft.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/6.webp',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Produk J',
        'harga': 140000.0,
        'stok': 20,
        'deskripsi':
            'Scented organic soy candle in a hand-poured concrete jar.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/7.webp',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Produk K',
        'harga': 85000.0,
        'stok': 45,
        'deskripsi':
            'Gourmet roasted Arabica coffee beans from Gayo highlands.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/11.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Produk L',
        'harga': 500000.0,
        'stok': 12,
        'deskripsi':
            'Minimalist leather wallet handcrafted with genuine full-grain leather.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/12.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Produk M',
        'harga': 110000.0,
        'stok': 28,
        'deskripsi':
            'Artisan hand-painted ceramic mug, safe for microwave and dishwasher.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/13.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Produk N',
        'harga': 275000.0,
        'stok': 16,
        'deskripsi':
            'Vintage design mechanical keyboard, quiet switches and warm backlight.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/14.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Produk O',
        'harga': 95000.0,
        'stok': 33,
        'deskripsi':
            'Organic lavender aromatherapy essential oil set for relaxation.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/15.jpg',
        'toko': 'Abadi Jaya Store',
      },
    ];

    for (var prod in products) {
      await db.insert('products', prod);
    }

    // Seed targets
    final targets = [
      {
        'bulan': 'Juni 2026',
        'targetJumlah': 30000000.0,
        'tercapaiJumlah': 15000000.0,
        'status': 'Belum Tercapai',
      },
      {
        'bulan': 'Juli 2026',
        'targetJumlah': 28000000.0,
        'tercapaiJumlah': 28000000.0,
        'status': 'Tercapai',
      },
      {
        'bulan': 'Agustus 2026',
        'targetJumlah': 35000000.0,
        'tercapaiJumlah': 10000000.0,
        'status': 'Belum Tercapai',
      },
    ];

    for (var target in targets) {
      await db.insert('targets', target);
    }

    // Seed activities
    final activities = [
      {
        'kodePesanan': '#BM-1001',
        'tanggal': '12 Mei 2024',
        'total': 150000.0,
        'status': 'Selesai',
        'alamat': 'Jl. Diponegoro No. 1, Medan, Sumatera Utara',
        'koordinatX': 0.12,
        'koordinatY': 0.22,
        'namaProduk': 'Produk A',
        'jumlah': 1,
      },
      {
        'kodePesanan': '#BM-1002',
        'tanggal': '13 Mei 2024',
        'total': 400000.0,
        'status': 'Selesai',
        'alamat': 'Jl. Jenderal Sudirman No. 2, Jakarta Pusat, DKI Jakarta',
        'koordinatX': 0.36,
        'koordinatY': 0.67,
        'namaProduk': 'Produk B',
        'jumlah': 2,
      },
      {
        'kodePesanan': '#BM-1003',
        'tanggal': '14 Mei 2024',
        'total': 75000.0,
        'status': 'Pending',
        'alamat': 'Jl. Ahmad Yani No. 3, Balikpapan, Kalimantan Timur',
        'koordinatX': 0.55,
        'koordinatY': 0.38,
        'namaProduk': 'Produk C',
        'jumlah': 1,
      },
      {
        'kodePesanan': '#BM-1004',
        'tanggal': '10 Juni 2026',
        'total': 450000.0,
        'status': 'Selesai',
        'alamat': 'Jl. AP Pettarani No. 4, Makassar, Sulawesi Selatan',
        'koordinatX': 0.63,
        'koordinatY': 0.53,
        'namaProduk': 'Produk A',
        'jumlah': 3,
      },
      {
        'kodePesanan': '#BM-1005',
        'tanggal': '12 Juni 2026',
        'total': 600000.0,
        'status': 'Selesai',
        'alamat': 'Jl. Raya Puputan No. 5, Denpasar, Bali',
        'koordinatX': 0.59,
        'koordinatY': 0.73,
        'namaProduk': 'Produk B',
        'jumlah': 3,
      },
      {
        'kodePesanan': '#BM-1006',
        'tanggal': '15 Juni 2026',
        'total': 1200000.0,
        'status': 'Selesai',
        'alamat': 'Jl. Sentani No. 6, Jayapura, Papua',
        'koordinatX': 0.96,
        'koordinatY': 0.46,
        'namaProduk': 'Produk A',
        'jumlah': 8,
      },
      {
        'kodePesanan': '#BM-1007',
        'tanggal': '20 Juni 2026',
        'total': 300000.0,
        'status': 'Selesai',
        'alamat': 'Jl. Pahlawan No. 7, Surabaya, Jawa Timur',
        'koordinatX': 0.54,
        'koordinatY': 0.71,
        'namaProduk': 'Produk C',
        'jumlah': 4,
      },
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

  Future<UserModelBizgrow?> getUserByEmail(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (res.isNotEmpty) {
        return UserModelBizgrow.fromMap(res.first);
      }
    } catch (e) {
      log("Error getting user by email: $e");
    }
    return null;
  }

  // Update user profile in database
  Future<bool> updateUser(
    String oldEmail,
    String newName,
    String newEmail,
    String newNik,
  ) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        {'nama': newName, 'email': newEmail, 'nik': newNik},
        where: 'email = ?',
        whereArgs: [oldEmail],
      );
      return count > 0;
    } catch (e) {
      log("Error updating user profile: $e");
      return false;
    }
  }

  // Update user profile password in database
  Future<bool> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
      return count > 0;
    } catch (e) {
      log("Error updating user password: $e");
      return false;
    }
  }

  // Get new owner registered in database
  Future<Map<String, String>?> getNewOwner() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'users',
        where: "role = 'Owner' AND email != 'rania@gmail.com'",
        limit: 1,
      );
      if (res.isNotEmpty) {
        return {
          'nama': res.first['nama']?.toString() ?? '',
          'email': res.first['email']?.toString() ?? '',
        };
      }
    } catch (e) {
      log("Error getting new owner: $e");
    }
    return null;
  }

  // Update user profile image path in database
  Future<bool> updateUserProfileImage(String email, String? imagePath) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        {'profileImage': imagePath},
        where: 'email = ?',
        whereArgs: [email],
      );
      return count > 0;
    } catch (e) {
      log("Error updating user profile image: $e");
      return false;
    }
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

  Future<ProductModel?> getProductById(int id) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (res.isNotEmpty) {
        return ProductModel.fromMap(res.first);
      }
    } catch (e) {
      log("Error getting product by id: $e");
    }
    return null;
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

  Future<bool> addActivity(ActivityModel activity) async {
    final db = await database;
    try {
      // Check if an activity with same kodePesanan and namaProduk already exists
      final existing = await db.query(
        'activities',
        where: 'kodePesanan = ? AND namaProduk = ?',
        whereArgs: [activity.kodePesanan, activity.namaProduk ?? ''],
      );
      if (existing.isNotEmpty) {
        // Update existing activity instead of duplicate insert
        int count = await db.update(
          'activities',
          activity.toMap(),
          where: 'kodePesanan = ? AND namaProduk = ?',
          whereArgs: [activity.kodePesanan, activity.namaProduk ?? ''],
        );
        return count > 0;
      } else {
        await db.insert('activities', activity.toMap());
        return true;
      }
    } catch (e) {
      log("Error adding or updating activity: $e");
      return false;
    }
  }

  Future<List<ActivityModel>> getActivitiesByBuyer(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'activities',
        where: 'buyerEmail = ?',
        whereArgs: [email],
        orderBy: 'id DESC',
      );
      return res.map((m) => ActivityModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting activities by buyer: $e");
      return [];
    }
  }

  Future<List<ActivityModel>> getActivitiesByOrderCode(
    String kodePesanan,
  ) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'activities',
        where: 'kodePesanan = ?',
        whereArgs: [kodePesanan],
      );
      return res.map((m) => ActivityModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting activities by order code: $e");
      return [];
    }
  }

  Future<bool> updateActivityStatus(int id, String newStatus) async {
    final db = await database;
    try {
      int count = await db.update(
        'activities',
        {'status': newStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      log("Error updating activity status: $e");
      return false;
    }
  }

  Future<bool> updateProductStock(int id, int newStock) async {
    final db = await database;
    try {
      int count = await db.update(
        'products',
        {
          'stok': newStock,
          'status': newStock > 0 ? 'Tersedia' : 'Tidak Tersedia',
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      log("Error updating stock: $e");
      return false;
    }
  }

  // Cart Operations
  Future<List<CartItemModel>> getCart(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.rawQuery(
        '''
        SELECT c.*, p.nama, p.harga, p.gambar, p.stok
        FROM cart c
        JOIN products p ON c.productId = p.id
        WHERE c.buyerEmail = ?
      ''',
        [email],
      );
      return res
          .map(
            (m) => CartItemModel.fromMap(
              m,
              nama: m['nama'] as String? ?? '',
              harga: (m['harga'] as num? ?? 0.0).toDouble(),
              gambar: m['gambar'] as String?,
              stok: m['stok'] as int? ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      log("Error getting cart: $e");
      return [];
    }
  }

  Future<bool> addToCart(int productId, String email, int qty) async {
    final db = await database;
    try {
      // Get current total cart quantity
      final totalQtyRes = await db.rawQuery(
        'SELECT SUM(jumlah) as total FROM cart WHERE buyerEmail = ?',
        [email],
      );
      int currentTotal = 0;
      if (totalQtyRes.isNotEmpty && totalQtyRes.first['total'] != null) {
        currentTotal = totalQtyRes.first['total'] as int;
      }

      // Check if product exists in cart
      final existing = await db.query(
        'cart',
        where: 'productId = ? AND buyerEmail = ?',
        whereArgs: [productId, email],
      );

      if (currentTotal + qty > 100) {
        return false; // Exceeds 100 item limit
      }

      if (existing.isNotEmpty) {
        final newQty = (existing.first['jumlah'] as int) + qty;
        await db.update(
          'cart',
          {'jumlah': newQty},
          where: 'productId = ? AND buyerEmail = ?',
          whereArgs: [productId, email],
        );
      } else {
        await db.insert('cart', {
          'productId': productId,
          'buyerEmail': email,
          'jumlah': qty,
        });
      }
      return true;
    } catch (e) {
      log("Error adding to cart: $e");
      return false;
    }
  }

  Future<bool> updateCartItemQuantity(int id, int newQty, String email) async {
    final db = await database;
    try {
      final itemRes = await db.query('cart', where: 'id = ?', whereArgs: [id]);
      if (itemRes.isEmpty) return false;
      final oldQty = itemRes.first['jumlah'] as int;

      final totalQtyRes = await db.rawQuery(
        'SELECT SUM(jumlah) as total FROM cart WHERE buyerEmail = ?',
        [email],
      );
      int currentTotal = 0;
      if (totalQtyRes.isNotEmpty && totalQtyRes.first['total'] != null) {
        currentTotal = totalQtyRes.first['total'] as int;
      }

      int netChange = newQty - oldQty;
      if (currentTotal + netChange > 100) {
        return false;
      }

      if (newQty <= 0) {
        await db.delete('cart', where: 'id = ?', whereArgs: [id]);
      } else {
        await db.update(
          'cart',
          {'jumlah': newQty},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
      return true;
    } catch (e) {
      log("Error updating cart item quantity: $e");
      return false;
    }
  }

  Future<void> removeFromCart(int id) async {
    final db = await database;
    try {
      await db.delete('cart', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log("Error removing from cart: $e");
    }
  }

  Future<void> clearCart(String email) async {
    final db = await database;
    try {
      await db.delete('cart', where: 'buyerEmail = ?', whereArgs: [email]);
    } catch (e) {
      log("Error clearing cart: $e");
    }
  }

  Future<void> clearSelectedCartItems(
    String email,
    List<String> productNames,
  ) async {
    final db = await database;
    try {
      for (var name in productNames) {
        final prodRes = await db.query(
          'products',
          where: 'nama = ?',
          whereArgs: [name],
        );
        if (prodRes.isNotEmpty) {
          final prodId = prodRes.first['id'] as int;
          await db.delete(
            'cart',
            where: 'buyerEmail = ? AND productId = ?',
            whereArgs: [email, prodId],
          );
        }
      }
    } catch (e) {
      log("Error clearing selected cart items: $e");
    }
  }

  Future<List<ProductModel>> getProductsByShop(String shopName) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> res = await db.query(
        'products',
        where: 'toko = ?',
        whereArgs: [shopName],
      );
      return res.map((m) => ProductModel.fromMap(m)).toList();
    } catch (e) {
      log("Error getting products by shop: $e");
      return [];
    }
  }
}
