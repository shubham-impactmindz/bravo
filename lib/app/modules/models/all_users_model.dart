// To parse this JSON data, do
//
//     final allUsersModel = allUsersModelFromJson(jsonString);

import 'dart:convert';

AllUsersModel allUsersModelFromJson(String str) => AllUsersModel.fromJson(json.decode(str));

String allUsersModelToJson(AllUsersModel data) => json.encode(data.toJson());

class AllUsersModel {
  bool? isSuccess;
  String? message;
  List<AllUser>? allUsers;

  AllUsersModel({
    this.isSuccess,
    this.message,
    this.allUsers,
  });

  factory AllUsersModel.fromJson(Map<String, dynamic> json) => AllUsersModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    allUsers: json["allUsers"] == null ? [] : List<AllUser>.from(json["allUsers"]!.map((x) => AllUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "allUsers": allUsers == null ? [] : List<dynamic>.from(allUsers!.map((x) => x.toJson())),
  };
}

class AllUser {
  String? userId;
  String? authrizationCode;
  String? username;
  String? password;
  String? email;
  String? roleId;
  String? isActive;
  dynamic lastLogin;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? firstName;
  String? lastName;
  String? phone;
  String? gender;
  String? address;
  String? suburb;
  String? state;
  String? country;
  String? postalCode;
  DateTime? dateOfBirth;
  String? profilePicture;
  String? age;
  String? notes;
  String? deviceToken;

  AllUser({
    this.userId,
    this.authrizationCode,
    this.username,
    this.password,
    this.email,
    this.roleId,
    this.isActive,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.phone,
    this.gender,
    this.address,
    this.suburb,
    this.state,
    this.country,
    this.postalCode,
    this.dateOfBirth,
    this.profilePicture,
    this.age,
    this.notes,
    this.deviceToken,
  });

  factory AllUser.fromJson(Map<String, dynamic> json) => AllUser(
    userId: json["user_id"],
    authrizationCode: json["authrization_code"],
    username: json["username"],
    password: json["password"],
    email: json["email"],
    roleId: json["role_id"],
    isActive: json["is_active"],
    lastLogin: json["last_login"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    gender: json["gender"],
    address: json["address"],
    suburb: json["suburb"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postal_code"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    profilePicture: json["profile_picture"],
    age: json["age"],
    notes: json["notes"],
    deviceToken: json["device_token"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "authrization_code": authrizationCode,
    "username": username,
    "password": password,
    "email": email,
    "role_id": roleId,
    "is_active": isActive,
    "last_login": lastLogin,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "gender": gender,
    "address": address,
    "suburb": suburb,
    "state": state,
    "country": country,
    "postal_code": postalCode,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "age": age,
    "notes": notes,
    "device_token": deviceToken,
  };
}
