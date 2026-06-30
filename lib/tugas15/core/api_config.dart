import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Mengambil dari Postman Collection: https://appabsensi.mobileprojp.com
  static const String baseUrl = 'https://appabsensi.mobileprojp.com/api';
  
  static String get register => '$baseUrl/register';
  static String get login => '$baseUrl/login';
  static String get profile => '$baseUrl/profile';
  static String get profilePhoto => '$baseUrl/profile/photo';
  static String get users => '$baseUrl/users';
  static String get trainings => '$baseUrl/trainings';
  static String get batches => '$baseUrl/batches';
}
