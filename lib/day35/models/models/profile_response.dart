import 'dart:convert';

import 'package:flutter_application_1/day35/models/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part '../service/profile_response.g.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  UserModel? data;

  ProfileResponse({this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
