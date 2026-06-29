import 'package:dio/dio.dart';
import 'package:flutter_application_1/Day_33/models/post_models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(
  baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('search.php?s=chicken')
  Future<PostModel> getAllPosts();

  @GET('search.php')
  Future<PostModel> searchMeals(@Query('s') String query);
}
