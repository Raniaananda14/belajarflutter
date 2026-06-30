import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_config.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.headers['Accept'] = 'application/json';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Register
  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post(ApiConfig.register, data: data);
  }

  // Login
  Future<Response> login(Map<String, dynamic> data) async {
    return await _dio.post(ApiConfig.login, data: data);
  }

  // Get Profile
  Future<Response> getProfile() async {
    return await _dio.get(ApiConfig.profile);
  }

  // Update Profile
  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _dio.put(ApiConfig.profile, data: data);
  }

  // Update Profile Photo
  Future<Response> updateProfilePhoto(FormData data) async {
    // Postman indicates PUT for edit profile photo, but often with FormData it might need POST + _method: PUT,
    // Kita gunakan POST atau PUT sesuai konvensi backend.
    return await _dio.post(ApiConfig.profilePhoto, data: data); 
  }

  // Get Trainings
  Future<Response> getTrainings() async {
    return await _dio.get(ApiConfig.trainings);
  }

  // Get Batches
  Future<Response> getBatches() async {
    return await _dio.get(ApiConfig.batches);
  }

  // Get Users
  Future<Response> getUsers() async {
    return await _dio.get(ApiConfig.users);
  }
}
