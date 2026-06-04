import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModels {
  final int id;
  final String username;
  final String email;
  final String password;
  UserModels({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModels.fromJson(String source) =>
      UserModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
