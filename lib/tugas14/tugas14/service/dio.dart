import 'package:dio/dio.dart';

Dio mealDB() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ), // BaseOptions
  ); // Dio

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
