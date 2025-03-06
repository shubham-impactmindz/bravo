// To parse this JSON data, do
//
//     final studentDetailModel = studentDetailModelFromJson(jsonString);

import 'dart:convert';

StudentDetailModel studentDetailModelFromJson(String str) => StudentDetailModel.fromJson(json.decode(str));

String studentDetailModelToJson(StudentDetailModel data) => json.encode(data.toJson());

class StudentDetailModel {
  bool? isSuccess;
  String? message;
  List<Participant>? participants;

  StudentDetailModel({
    this.isSuccess,
    this.message,
    this.participants,
  });

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) => StudentDetailModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    participants: json["userData"] == null ? [] : List<Participant>.from(json["userData"]!.map((x) => Participant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "userData": participants == null ? [] : List<dynamic>.from(participants!.map((x) => x.toJson())),
  };
}

class Participant {
  String? userId;
  String? username;
  String? email;
  String? roleId;
  String? firstName;
  String? lastName;
  String? name;
  String? phone;
  String? address;
  String? suburb;
  String? state;
  String? country;
  String? postalCode;
  DateTime? dateOfBirth;
  String? profilePicture;
  List<FamilyRelationship>? familyRelationships;

  Participant({
    this.userId,
    this.username,
    this.email,
    this.roleId,
    this.firstName,
    this.lastName,
    this.name,
    this.phone,
    this.address,
    this.suburb,
    this.state,
    this.country,
    this.postalCode,
    this.dateOfBirth,
    this.profilePicture,
    this.familyRelationships,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    userId: json["user_id"],
    username: json["username"],
    email: json["email"],
    roleId: json["role_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    suburb: json["suburb"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postal_code"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    profilePicture: json["profile_picture"],
    familyRelationships: json["family_relationships"] == null ? [] : List<FamilyRelationship>.from(json["family_relationships"]!.map((x) => FamilyRelationship.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "email": email,
    "role_id": roleId,
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
    "phone": phone,
    "address": address,
    "suburb": suburb,
    "state": state,
    "country": country,
    "postal_code": postalCode,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "family_relationships": familyRelationships == null ? [] : List<dynamic>.from(familyRelationships!.map((x) => x.toJson())),
  };
}

class FamilyRelationship {
  String? relationshipId;
  String? relativeId;
  String? relationshipTypeId;
  String? relationshipTypeName;
  String? firstName;
  String? lastName;
  String? relativeName;
  String? phone;
  String? email;
  String? address;

  FamilyRelationship({
    this.relationshipId,
    this.relativeId,
    this.relationshipTypeId,
    this.relationshipTypeName,
    this.firstName,
    this.lastName,
    this.relativeName,
    this.phone,
    this.email,
    this.address,
  });

  factory FamilyRelationship.fromJson(Map<String, dynamic> json) => FamilyRelationship(
    relationshipId: json["relationship_id"],
    relativeId: json["relative_id"],
    relationshipTypeId: json["relationship_type_id"],
    relationshipTypeName: json["relationship_type_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    relativeName: json["relative_name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "relationship_id": relationshipId,
    "relative_id": relativeId,
    "relationship_type_id": relationshipTypeId,
    "relationship_type_name": relationshipTypeName,
    "first_name": firstName,
    "last_name": lastName,
    "relative_name": relativeName,
    "phone": phone,
    "email": email,
    "address": address,
  };
}
