// To parse this JSON data, do
//
//     final updateProfilePictureModel = updateProfilePictureModelFromJson(jsonString);

import 'dart:convert';

UpdateProfilePictureModel updateProfilePictureModelFromJson(String str) => UpdateProfilePictureModel.fromJson(json.decode(str));

String updateProfilePictureModelToJson(UpdateProfilePictureModel data) => json.encode(data.toJson());

class UpdateProfilePictureModel {
  bool? isSuccess;
  String? message;
  String? profilePicture;

  UpdateProfilePictureModel({
    this.isSuccess,
    this.message,
    this.profilePicture,
  });

  factory UpdateProfilePictureModel.fromJson(Map<String, dynamic> json) => UpdateProfilePictureModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "profile_picture": profilePicture,
  };
}
