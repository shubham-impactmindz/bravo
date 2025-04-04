// To parse this JSON data, do
//
//     final userChatsModel = userChatsModelFromJson(jsonString);

import 'dart:convert';

UserChatsListModel userChatsModelFromJson(String str) => UserChatsListModel.fromJson(json.decode(str));

String userChatsModelToJson(UserChatsListModel data) => json.encode(data.toJson());

class UserChatsListModel {
  bool? isSuccess;
  String? message;
  bool? isActive;
  UserInfo? userInfo;
  List<Chat>? chats;
  Pagination? pagination;

  UserChatsListModel({
    this.isSuccess,
    this.message,
    this.isActive,
    this.userInfo,
    this.chats,
    this.pagination,
  });

  factory UserChatsListModel.fromJson(Map<String, dynamic> json) => UserChatsListModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    isActive: json["is_active"],
    userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    chats: json["chats"] == null ? [] : List<Chat>.from(json["chats"]!.map((x) => Chat.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "is_active": isActive,
    "userInfo": userInfo?.toJson(),
    "chats": chats == null ? [] : List<dynamic>.from(chats!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Chat {
  String? type;
  int? chatId;
  String? name;
  String? profilePic;
  String? isActive;
  LastMessage? lastMessage;

  Chat({
    this.type,
    this.chatId,
    this.name,
    this.profilePic,
    this.isActive,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    type: json["type"],
    chatId: json["chat_id"],
    name: json["name"],
    profilePic: json["profilePic"],
    isActive: json["is_active"],
    lastMessage: json["lastMessage"] == null ? null : LastMessage.fromJson(json["lastMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "chat_id": chatId,
    "name": name,
    "profilePic": profilePic,
    "is_active": isActive,
    "lastMessage": lastMessage?.toJson(),
  };
}

class LastMessage {
  String? messageId;
  String? senderId;
  String? senderName;
  String? messageText;
  String? messageType;
  String? messageUrl;
  DateTime? timestamp;
  String? isRead;
  String? chatType;

  LastMessage({
    this.messageId,
    this.senderId,
    this.senderName,
    this.messageText,
    this.messageType,
    this.messageUrl,
    this.timestamp,
    this.isRead,
    this.chatType,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    messageId: json["messageId"],
    senderId: json["senderId"],
    senderName: json["senderName"],
    messageText: json["messageText"],
    messageType: json["messageType"],
    messageUrl: json["messageUrl"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    isRead: json["is_read"],
    chatType: json["chatType"],
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "senderId": senderId,
    "senderName": senderName,
    "messageText": messageText,
    "messageType": messageType,
    "messageUrl": messageUrl,
    "timestamp": timestamp?.toIso8601String(),
    "is_read": isRead,
    "chatType": chatType,
  };
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
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
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "role": role,
  };
}
