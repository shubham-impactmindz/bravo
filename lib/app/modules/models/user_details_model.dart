// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  bool? isSuccess;
  String? message;
  UserInfo? userInfo;
  String? groupInfo;

  UserDetailsModel({
    this.isSuccess,
    this.message,
    this.userInfo,
    this.groupInfo,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    groupInfo: json["groupInfo"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "userInfo": userInfo?.toJson(),
    "groupInfo": groupInfo,
  };
}

class UserInfo {
  String? userId;
  String? authrizationCode;
  String? email;
  String? fullname;
  String? firstName;
  String? lastName;
  String? username;
  String? phone;
  String? gender;
  String? address;
  String? suburb;
  String? state;
  String? country;
  String? postalCode;
  DateTime? dateOfBirth;
  String? profilePicture;
  String? role;

  UserInfo({
    this.userId,
    this.authrizationCode,
    this.email,
    this.fullname,
    this.firstName,
    this.lastName,
    this.username,
    this.phone,
    this.gender,
    this.address,
    this.suburb,
    this.state,
    this.country,
    this.postalCode,
    this.dateOfBirth,
    this.profilePicture,
    this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json["user_id"],
    authrizationCode: json["authrization_code"],
    email: json["email"],
    fullname: json["fullname"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    phone: json["phone"],
    gender: json["gender"],
    address: json["address"],
    suburb: json["suburb"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postal_code"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    profilePicture: json["profile_picture"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "authrization_code": authrizationCode,
    "email": email,
    "fullname": fullname,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "phone": phone,
    "gender": gender,
    "address": address,
    "suburb": suburb,
    "state": state,
    "country": country,
    "postal_code": postalCode,
    "date_of_birth": "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "role": role,
  };
}