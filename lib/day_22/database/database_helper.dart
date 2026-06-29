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
    final path = join(dbPath, 'bizgrow_day22_v14.db');

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
        'nama': 'Vas Bunga Keramik Minimalis',
        'harga': 150000.0,
        'stok': 35,
        'deskripsi':
            'Vas bunga keramik dengan desain minimalis modern dan tekstur alami yang elegan untuk dekorasi rumah Anda.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/1.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Tas Anyaman Bambu Premium',
        'harga': 200000.0,
        'stok': 40,
        'deskripsi':
            'Tas jinjing anyaman bambu premium khas pengrajin lokal. Ringan, organik, ramah lingkungan, dan sangat modis.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/3.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Syal Batik Tulis Indigo',
        'harga': 75000.0,
        'stok': 10,
        'deskripsi':
            'Syal batik tulis tradisional bermotif indah dengan pewarna alami dari tanaman indigo Jawa.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/8.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Mangkuk Kayu Jati Solid',
        'harga': 120000.0,
        'stok': 18,
        'deskripsi':
            'Mangkuk saji dari akar kayu jati pilihan Jawa Timur, menampilkan serat kayu eksotis dan bentuk alami yang unik.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/9.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Terrarium Kaca Hexagonal (Habis)',
        'harga': 90000.0,
        'stok': 0,
        'deskripsi':
            'Terrarium kaca geometris modern dengan detail bingkai kuningan mewah, cocok untuk tanaman hias sukulen.',
        'kategori': 'Lainnya',
        'status': 'Tidak Tersedia',
        'gambar': 'assets/images/10.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Nampan Saji Kayu Mahoni',
        'harga': 180000.0,
        'stok': 25,
        'deskripsi':
            'Nampan saji kayu mahoni dengan gaya rustic natural, dilapisi pelindung food-grade aman untuk makanan.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/2.webp',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Mouse Wireless Silent Premium',
        'harga': 350000.0,
        'stok': 15,
        'deskripsi':
            'Mouse nirkabel ergonomis premium dengan sensor presisi tinggi dan klik senyap (silent click), mendukung multi-device.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/4.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Madu Hutan Multiflora Organik',
        'harga': 65000.0,
        'stok': 50,
        'deskripsi':
            'Madu hutan murni multiflora mentah (raw honey), dipanen langsung secara alami tanpa tambahan gula atau pengawet.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/5.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Kemeja Linen Casual Premium',
        'harga': 220000.0,
        'stok': 30,
        'deskripsi':
            'Kemeja casual berbahan 100% serat linen alami berkualitas tinggi. Sangat lembut, sejuk, dan nyaman dipakai harian.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/6.webp',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Lilin Aromaterapi Soy Wax',
        'harga': 140000.0,
        'stok': 20,
        'deskripsi':
            'Lilin aromaterapi wangi menenangkan dari bahan soy wax organik di dalam wadah semen minimalis buatan tangan.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/7.webp',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Biji Kopi Arabika Gayo',
        'harga': 85000.0,
        'stok': 45,
        'deskripsi':
            'Biji kopi Arabika premium dari dataran tinggi Gayo, Aceh. Diproses secara semi-washed dan disangrai tingkat medium.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/11.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Dompet Kulit Asli Handmade',
        'harga': 500000.0,
        'stok': 12,
        'deskripsi':
            'Dompet kulit sapi asli buatan tangan dengan desain minimalis ramping, memiliki slot kartu dan kompartemen uang.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/12.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Cangkir Keramik Lukis Hand-painted',
        'harga': 110000.0,
        'stok': 28,
        'deskripsi':
            'Cangkir keramik lukis tangan artistik dengan motif floral unik, aman digunakan di microwave dan mesin pencuci piring.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/13.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Keyboard Mekanikal Retro Bluetooth',
        'harga': 275000.0,
        'stok': 16,
        'deskripsi':
            'Keyboard mekanikal nirkabel bergaya mesin ketik retro klasik dengan switch taktil senyap dan lampu latar hangat.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/14.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Minyak Atsiri Essential Oil Lavender',
        'harga': 95000.0,
        'stok': 33,
        'deskripsi':
            'Set minyak atsiri (essential oil) lavender organik 100% murni untuk relaksasi, membantu tidur nyenyak, dan meredakan stres.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/15.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Powerbank Fast Charging 10000mAh',
        'harga': 195000.0,
        'stok': 25,
        'deskripsi':
            'Powerbank dengan pengisian cepat 22.5W, desain ultra-thin slim, indikator LED, perlindungan sirkuit ganda.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/el_1.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Earphone TWS Bluetooth 5.3',
        'harga': 299000.0,
        'stok': 30,
        'deskripsi':
            'TWS earphone nirkabel dengan driver dinamis 13mm, deep bass, noise reduction, tahan air IPX4, baterai tahan 24 jam.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/el_2.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Speaker Bluetooth Portable Waterproof',
        'harga': 450000.0,
        'stok': 12,
        'deskripsi':
            'Speaker bluetooth portable dengan suara stereo bass kencang, baterai tahan 12 jam, sertifikasi tahan air IPX7 cocok untuk outdoor.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/el_3.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Lampu Meja LED Smart Touch',
        'harga': 135000.0,
        'stok': 40,
        'deskripsi':
            'Lampu meja LED dengan sensor sentuh, 3 mode pencahayaan (hangat, putih, natural), pengisian daya USB dan pelindung mata.',
        'kategori': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/el_4.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Jaket Hoodie Katun Fleece',
        'harga': 250000.0,
        'stok': 15,
        'deskripsi':
            'Jaket hoodie premium unisex terbuat dari bahan katun fleece tebal dan lembut, sangat nyaman dipakai saat cuaca dingin.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/pk_1.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Celana Chino Slim Fit Pria',
        'harga': 195000.0,
        'stok': 20,
        'deskripsi':
            'Celana panjang chino slim fit untuk pria, berbahan katun stretch melar yang elastis, lembut, dan tidak panas.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/pk_2.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Topi Canvas Vintage Baseball',
        'harga': 65000.0,
        'stok': 50,
        'deskripsi':
            'Topi baseball bergaya retro vintage terbuat dari bahan kanvas katun washed yang kokoh dengan pengatur ukuran besi.',
        'kategori': 'Pakaian',
        'status': 'Tersedia',
        'gambar': 'assets/images/pk_3.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Keripik Tempe Goreng Renyah',
        'harga': 25000.0,
        'stok': 100,
        'deskripsi':
            'Keripik tempe tipis renyah rasa gurih bawang ketumbar, diolah dengan minyak bersih secara tradisional bebas pengawet.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/mk_1.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Teh Hijau Melati Organik',
        'harga': 45000.0,
        'stok': 60,
        'deskripsi':
            'Daun teh hijau pilihan berkualitas tinggi yang dipadukan dengan kuntum bunga melati asli untuk aroma harum menenangkan.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/mk_2.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Selai Kacang Tanah Creamy',
        'harga': 55000.0,
        'stok': 45,
        'deskripsi':
            'Selai kacang tanah panggang murni tanpa minyak tambahan, rendah gula, tekstur sangat creamy, gurih dan kaya protein.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/mk_3.jpg',
        'toko': 'BizGrow Jakarta Barat',
      },
      {
        'nama': 'Cokelat Hitam Artisan 70%',
        'harga': 38000.0,
        'stok': 80,
        'deskripsi':
            'Artisan dark chocolate bar dengan kadar kakao 70% asli dari perkebunan cokelat lokal Indonesia, rasa intens dan premium.',
        'kategori': 'Makanan',
        'status': 'Tersedia',
        'gambar': 'assets/images/mk_4.jpg',
        'toko': 'Karya Mandiri Shop',
      },
      {
        'nama': 'Notebook Jurnal Kulit A5',
        'harga': 85000.0,
        'stok': 35,
        'deskripsi':
            'Buku catatan jurnal ukuran A5 dengan sampul kulit sintetis bertekstur, kertas bergaris ramah tinta pena air.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/ln_1.jpg',
        'toko': 'Abadi Jaya Store',
      },
      {
        'nama': 'Pajangan Dinding Macrame Leaf',
        'harga': 120000.0,
        'stok': 15,
        'deskripsi':
            'Hiasan gantungan dinding rajut macrame bermotif daun dari benang katun alami, menambah kesan boho estetik pada ruangan.',
        'kategori': 'Lainnya',
        'status': 'Tersedia',
        'gambar': 'assets/images/ln_2.jpg',
        'toko': 'BizGrow Jakarta Barat',
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
        'namaProduk': 'Vas Bunga Keramik Minimalis',
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
        'namaProduk': 'Tas Anyaman Bambu Premium',
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
        'namaProduk': 'Syal Batik Tulis Indigo',
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
        'namaProduk': 'Vas Bunga Keramik Minimalis',
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
        'namaProduk': 'Tas Anyaman Bambu Premium',
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
        'namaProduk': 'Vas Bunga Keramik Minimalis',
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
        'namaProduk': 'Syal Batik Tulis Indigo',
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
