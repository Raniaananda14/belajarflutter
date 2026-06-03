import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModelBizgrow {
  final int? id;
  final String email;
  final String password;
  final String nik;
  UserModelBizgrow({
    this.id,
    required this.email,
    required this.password,
    required this.nik,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'nik': nik,
    };
  }

  factory UserModelBizgrow.fromMap(Map<String, dynamic> map) {
    return UserModelBizgrow(
      id: map['id'] != null ? map['id'] as int : null,
      email: map['email'] as String,
      password: map['password'] as String,
      nik: map['nik'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelBizgrow.fromJson(String source) =>
      UserModelBizgrow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModelBizgrow(id: $id, email: $email, password: $password, nik: $nik)';
  }
}

class UserLoginModels {
  final String email;
  final String password;
  UserLoginModels({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'email': email, 'password': password};
  }

  factory UserLoginModels.fromMap(Map<String, dynamic> map) {
    return UserLoginModels(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginModels.fromJson(String source) =>
      UserLoginModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
