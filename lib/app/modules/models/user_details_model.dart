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
  List<GroupInfo>? groupInfo;

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
    groupInfo: json["groupInfo"] == null ? [] : List<GroupInfo>.from(json["groupInfo"]!.map((x) => GroupInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "userInfo": userInfo?.toJson(),
    "groupInfo": groupInfo == null ? [] : List<dynamic>.from(groupInfo!.map((x) => x.toJson())),
  };
}

class GroupInfo {
  int? groupId;
  String? groupIdType;
  String? name;
  String? description;
  String? createdBy;
  dynamic parentGroupId;
  String? groupPicture;
  String? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  LastMessage? lastMessage;

  GroupInfo({
    this.groupId,
    this.groupIdType,
    this.name,
    this.description,
    this.createdBy,
    this.parentGroupId,
    this.groupPicture,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) => GroupInfo(
    groupId: json["group_id"],
    groupIdType: json["group_id_type"],
    name: json["name"],
    description: json["description"],
    createdBy: json["created_by"],
    parentGroupId: json["parent_group_id"],
    groupPicture: json["group_picture"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    lastMessage: json["lastMessage"] == null ? null : LastMessage.fromJson(json["lastMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "group_id_type": groupIdType,
    "name": name,
    "description": description,
    "created_by": createdBy,
    "parent_group_id": parentGroupId,
    "group_picture": groupPicture,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "lastMessage": lastMessage?.toJson(),
  };
}

class LastMessage {
  String? messageId;
  String? senderId;
  String? chatId;
  dynamic parentMessageId;
  String? messageTypeId;
  String? content;
  String? isEdited;
  dynamic editTimestamp;
  String? isDeleted;
  dynamic deleteTimestamp;
  DateTime? sentAt;
  String? groupId;

  LastMessage({
    this.messageId,
    this.senderId,
    this.chatId,
    this.parentMessageId,
    this.messageTypeId,
    this.content,
    this.isEdited,
    this.editTimestamp,
    this.isDeleted,
    this.deleteTimestamp,
    this.sentAt,
    this.groupId,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    messageId: json["message_id"],
    senderId: json["sender_id"],
    chatId: json["chat_id"],
    parentMessageId: json["parent_message_id"],
    messageTypeId: json["message_type_id"],
    content: json["content"],
    isEdited: json["is_edited"],
    editTimestamp: json["edit_timestamp"],
    isDeleted: json["is_deleted"],
    deleteTimestamp: json["delete_timestamp"],
    sentAt: json["sent_at"] == null ? null : DateTime.parse(json["sent_at"]),
    groupId: json["group_id"],
  );

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
    "sender_id": senderId,
    "chat_id": chatId,
    "parent_message_id": parentMessageId,
    "message_type_id": messageTypeId,
    "content": content,
    "is_edited": isEdited,
    "edit_timestamp": editTimestamp,
    "is_deleted": isDeleted,
    "delete_timestamp": deleteTimestamp,
    "sent_at": sentAt?.toIso8601String(),
    "group_id": groupId,
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