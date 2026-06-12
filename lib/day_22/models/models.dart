class UserModelBizgrow {
  final int? id;
  final String nama;
  final String email;
  final String password;
  final String nik;
  final String? profileImage;
  final String role;
  final String? securityQuestion;
  final String? securityAnswer;

  UserModelBizgrow({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.nik,
    this.profileImage,
    this.role = "Pembeli",
    this.securityQuestion,
    this.securityAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'nik': nik,
      'profileImage': profileImage,
      'role': role,
      'securityQuestion': securityQuestion,
      'securityAnswer': securityAnswer,
    };
  }

  factory UserModelBizgrow.fromMap(Map<String, dynamic> map) {
    return UserModelBizgrow(
      id: map['id'] as int?,
      nama: map['nama'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      nik: map['nik'] as String? ?? '',
      profileImage: map['profileImage'] as String?,
      role: map['role'] as String? ?? 'Pembeli',
      securityQuestion: map['securityQuestion'] as String?,
      securityAnswer: map['securityAnswer'] as String?,
    );
  }
}

class ProductModel {
  final int? id;
  final String nama;
  final double harga;
  final int stok;
  final String deskripsi;
  final String kategori;
  final String status; // 'Tersedia' or 'Tidak Tersedia'
  final String? gambar;
  final String? toko;

  ProductModel({
    this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.deskripsi,
    required this.kategori,
    required this.status,
    this.gambar,
    this.toko,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'status': status,
      'gambar': gambar,
      if (toko != null) 'toko': toko,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final rawStatus = map['status'] as String? ?? 'Tersedia';
    final parsedStatus = rawStatus == 'Aktif'
        ? 'Tersedia'
        : rawStatus == 'Habis'
            ? 'Tidak Tersedia'
            : rawStatus;
            
    return ProductModel(
      id: map['id'] as int?,
      nama: map['nama'] as String? ?? '',
      harga: (map['harga'] as num? ?? 0.0).toDouble(),
      stok: map['stok'] as int? ?? 0,
      deskripsi: map['deskripsi'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      status: parsedStatus,
      gambar: map['gambar'] as String?,
      toko: map['toko'] as String?,
    );
  }
}

class TargetModel {
  final int? id;
  final String bulan; // e.g. "Juni 2024"
  final double targetJumlah;
  final double tercapaiJumlah;
  final String status; // 'Tercapai' or 'Belum Tercapai'

  TargetModel({
    this.id,
    required this.bulan,
    required this.targetJumlah,
    required this.tercapaiJumlah,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'bulan': bulan,
      'targetJumlah': targetJumlah,
      'tercapaiJumlah': tercapaiJumlah,
      'status': status,
    };
  }

  factory TargetModel.fromMap(Map<String, dynamic> map) {
    return TargetModel(
      id: map['id'] as int?,
      bulan: map['bulan'] as String? ?? '',
      targetJumlah: (map['targetJumlah'] as num? ?? 0.0).toDouble(),
      tercapaiJumlah: (map['tercapaiJumlah'] as num? ?? 0.0).toDouble(),
      status: map['status'] as String? ?? 'Belum Tercapai',
    );
  }
}

class ActivityModel {
  final int? id;
  final String kodePesanan; // e.g. "#BIZ-1001"
  final String tanggal; // e.g. "12 Mei 2024"
  final double total;
  final String status; // "Selesai" or "Pending"
  final String? alamat;
  final double? koordinatX;
  final double? koordinatY;
  final String? namaProduk;
  final int? jumlah;
  final String? buyerEmail; // email of the buyer who placed this order

  ActivityModel({
    this.id,
    required this.kodePesanan,
    required this.tanggal,
    required this.total,
    required this.status,
    this.alamat,
    this.koordinatX,
    this.koordinatY,
    this.namaProduk,
    this.jumlah,
    this.buyerEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'kodePesanan': kodePesanan,
      'tanggal': tanggal,
      'total': total,
      'status': status,
      'alamat': alamat,
      'koordinatX': koordinatX,
      'koordinatY': koordinatY,
      'namaProduk': namaProduk,
      'jumlah': jumlah,
      'buyerEmail': buyerEmail,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as int?,
      kodePesanan: map['kodePesanan'] as String? ?? '',
      tanggal: map['tanggal'] as String? ?? '',
      total: (map['total'] as num? ?? 0.0).toDouble(),
      status: map['status'] as String? ?? 'Selesai',
      alamat: map['alamat'] as String?,
      koordinatX: (map['koordinatX'] as num?)?.toDouble(),
      koordinatY: (map['koordinatY'] as num?)?.toDouble(),
      namaProduk: map['namaProduk'] as String?,
      jumlah: map['jumlah'] as int?,
      buyerEmail: map['buyerEmail'] as String?,
    );
  }
}

class CartItemModel {
  final int? id;
  final int productId;
  final String buyerEmail;
  final int jumlah;
  
  // Loaded via JOIN/lookups
  final String productNama;
  final double productHarga;
  final String? productGambar;
  final int productStok;

  CartItemModel({
    this.id,
    required this.productId,
    required this.buyerEmail,
    required this.jumlah,
    this.productNama = '',
    this.productHarga = 0.0,
    this.productGambar,
    this.productStok = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'buyerEmail': buyerEmail,
      'jumlah': jumlah,
    };
  }

  factory CartItemModel.fromMap(
    Map<String, dynamic> map, {
    String nama = '',
    double harga = 0.0,
    String? gambar,
    int stok = 0,
  }) {
    return CartItemModel(
      id: map['id'] as int?,
      productId: map['productId'] as int? ?? 0,
      buyerEmail: map['buyerEmail'] as String? ?? '',
      jumlah: map['jumlah'] as int? ?? 1,
      productNama: nama,
      productHarga: harga,
      productGambar: gambar,
      productStok: stok,
    );
  }
}
