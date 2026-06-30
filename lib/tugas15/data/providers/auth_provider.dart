import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.login({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        
        await getProfile(); // fetch profile info
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Login gagal. Cek email dan password.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem.';
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.register(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true; // Berhasil register, bisa redirect ke login
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Registrasi gagal.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      if (response.statusCode == 200) {
        _user = UserModel.fromJson(response.data['data']);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetch profile: $e');
    }
  }

  Future<bool> updateProfile(String name, String email, String jenisKelamin, {String? role, int? batchId, bool? statusAktif}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'jenis_kelamin': jenisKelamin,
      };
      
      if (role != null) data['role'] = role;
      if (batchId != null) data['batch_id'] = batchId;
      if (statusAktif != null) data['status_aktif'] = statusAktif ? 1 : 0;

      final response = await _apiService.updateProfile(data);

      if (response.statusCode == 200) {
        await getProfile(); // reload profile to get updated data
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Gagal memperbarui profil.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem.';
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateProfilePhoto(String imagePath) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'profile_photo': await MultipartFile.fromFile(imagePath),
      });

      final response = await _apiService.updateProfilePhoto(formData);
      if (response.statusCode == 200) {
        await getProfile(); // reload profile to get new image URL
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Gagal mengupload foto profil.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem saat upload foto.';
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _user = null;
    notifyListeners();
  }
}
