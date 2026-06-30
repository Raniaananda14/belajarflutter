import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<UserModel> _users = [];
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> getUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getUsers();
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        _users = data.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetch users: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
