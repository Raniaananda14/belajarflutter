class UserModelBizgrow {
  final int? id;
  final String nama;
  final String email;
  final String password;
  final String nik;
  final String? profileImage;

  UserModelBizgrow({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.nik,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'nik': nik,
      'profileImage': profileImage,
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
  final String status; // 'Aktif' or 'Habis'
  final String? gambar;

  ProductModel({
    this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.deskripsi,
    required this.kategori,
    required this.status,
    this.gambar,
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
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      nama: map['nama'] as String? ?? '',
      harga: (map['harga'] as num? ?? 0.0).toDouble(),
      stok: map['stok'] as int? ?? 0,
      deskripsi: map['deskripsi'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      status: map['status'] as String? ?? 'Aktif',
      gambar: map['gambar'] as String?,
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

  ActivityModel({
    this.id,
    required this.kodePesanan,
    required this.tanggal,
    required this.total,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'kodePesanan': kodePesanan,
      'tanggal': tanggal,
      'total': total,
      'status': status,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as int?,
      kodePesanan: map['kodePesanan'] as String? ?? '',
      tanggal: map['tanggal'] as String? ?? '',
      total: (map['total'] as num? ?? 0.0).toDouble(),
      status: map['status'] as String? ?? 'Selesai',
    );
  }
}
