import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/training_model.dart';
import '../models/batch_model.dart';

class TrainingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<TrainingModel> _trainings = [];
  List<BatchModel> _batches = [];
  bool _isLoading = false;

  List<TrainingModel> get trainings => _trainings;
  List<BatchModel> get batches => _batches;
  bool get isLoading => _isLoading;

  Future<void> getTrainings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getTrainings();
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        _trainings = data.map((e) => TrainingModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error getTrainings: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getBatches() async {
    try {
      final response = await _apiService.getBatches();
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        _batches = data.map((e) => BatchModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getBatches: $e');
    }
  }
}
