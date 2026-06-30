class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profilePhoto;
  final String? jenisKelamin;
  final int? batchId;
  final int? trainingId;
  final String? role;
  final bool? statusAktif;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhoto,
    this.jenisKelamin,
    this.batchId,
    this.trainingId,
    this.role,
    this.statusAktif,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profile_photo'],
      jenisKelamin: json['jenis_kelamin'],
      batchId: json['batch_id'] != null ? int.tryParse(json['batch_id'].toString()) : null,
      trainingId: json['training_id'] != null ? int.tryParse(json['training_id'].toString()) : null,
      role: json['role'],
      statusAktif: json['status_aktif'] != null 
          ? (json['status_aktif'].toString() == '1' || json['status_aktif'].toString().toLowerCase() == 'true')
          : null,
    );
  }
}
