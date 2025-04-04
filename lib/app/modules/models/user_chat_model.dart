// To parse this JSON data, do
//
//     final userChatModel = userChatModelFromJson(jsonString);

import 'dart:convert';

UserChatModel userChatModelFromJson(String str) => UserChatModel.fromJson(json.decode(str));

String userChatModelToJson(UserChatModel data) => json.encode(data.toJson());

class UserChatModel {
  bool? isSuccess;
  String? message;
  bool? isActive;
  List<Chat>? chats;

  UserChatModel({
    this.isSuccess,
    this.message,
    this.isActive,
    this.chats,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) => UserChatModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    isActive: json["is_active"],
    chats: json["chats"] == null ? [] : List<Chat>.from(json["chats"]!.map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "is_active": isActive,
    "chats": chats == null ? [] : List<dynamic>.from(chats!.map((x) => x.toJson())),
  };
}

class Chat {
  String? chatType;
  String? name;
  String? profilePic;
  String? userId;
  List<AllMessage>? allMessages;
  List<GroupMember>? groupMembers;
  MessagesPagination? messagesPagination;
  int? unreadCount;

  Chat({
    this.chatType,
    this.name,
    this.profilePic,
    this.userId,
    this.allMessages,
    this.groupMembers,
    this.messagesPagination,
    this.unreadCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    chatType: json["chatType"],
    name: json["name"],
    profilePic: json["profilePic"],
    userId: json["userId"],
    allMessages: json["allMessages"] == null ? [] : List<AllMessage>.from(json["allMessages"]!.map((x) => AllMessage.fromJson(x))),
    groupMembers: json["groupMembers"] == null ? [] : List<GroupMember>.from(json["groupMembers"]!.map((x) => GroupMember.fromJson(x))),
    messagesPagination: json["messagesPagination"] == null ? null : MessagesPagination.fromJson(json["messagesPagination"]),
    unreadCount: json["unreadCount"],
  );

  Map<String, dynamic> toJson() => {
    "chatType": chatType,
    "name": name,
    "profilePic": profilePic,
    "userId": userId,
    "allMessages": allMessages == null ? [] : List<dynamic>.from(allMessages!.map((x) => x.toJson())),
    "groupMembers": groupMembers == null ? [] : List<dynamic>.from(groupMembers!.map((x) => x.toJson())),
    "messagesPagination": messagesPagination?.toJson(),
    "unreadCount": unreadCount,
  };
}

class AllMessage {
  String? messageId;
  String? senderId;
  String? senderName;
  dynamic senderProfile;
  String? messageText;
  String? messageType;
  String? messageUrl;
  DateTime? timestamp;
  String? deviceTime;
  String? eventId;
  String? title;
  String? description;
  DateTime? startTime;
  DateTime? endTime;
  String? location;
  dynamic category;
  String? cost;
  String? eventDoc;
  String? eventNotes;
  String? createdBy;
  String? groupId;
  String? userId;
  int? isCancelled;
  dynamic cancellationReason;
  DateTime? createdAt;
  String? userStatus;

  AllMessage({
    this.messageId,
    this.senderId,
    this.senderName,
    this.senderProfile,
    this.messageText,
    this.messageType,
    this.messageUrl,
    this.timestamp,
    this.deviceTime,
    this.eventId,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.category,
    this.cost,
    this.eventDoc,
    this.eventNotes,
    this.createdBy,
    this.groupId,
    this.userId,
    this.isCancelled,
    this.cancellationReason,
    this.createdAt,
    this.userStatus,
  });

  factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
    messageId: json["messageId"],
    senderId: json["senderId"],
    senderName: json["senderName"],
    senderProfile: json["senderProfile"],
    messageText: json["messageText"],
    messageType: json["messageType"],
    messageUrl: json["messageUrl"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    deviceTime: json["device_time"],
    eventId: json["eventId"],
    title: json["title"],
    description: json["description"],
    startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    location: json["location"],
    category: json["category"],
    cost: json["cost"],
    eventDoc: json["eventDoc"],
    eventNotes: json["eventNotes"],
    createdBy: json["createdBy"],
    groupId: json["groupId"],
    userId: json["userId"],
    isCancelled: json["isCancelled"],
    cancellationReason: json["cancellationReason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    userStatus: json["userStatus"],
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "senderId": senderId,
    "senderName": senderName,
    "senderProfile": senderProfile,
    "messageText": messageText,
    "messageType": messageType,
    "messageUrl": messageUrl,
    "timestamp": timestamp?.toIso8601String(),
    "device_time": deviceTime,
    "eventId": eventId,
    "title": title,
    "description": description,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "location": location,
    "category": category,
    "cost": cost,
    "eventDoc": eventDoc,
    "eventNotes": eventNotes,
    "createdBy": createdBy,
    "groupId": groupId,
    "userId": userId,
    "isCancelled": isCancelled,
    "cancellationReason": cancellationReason,
    "created_at": createdAt?.toIso8601String(),
    "userStatus": userStatus,
  };
}

class GroupMember {
  String? userId;
  String? name;
  String? profilePic;

  GroupMember({
    this.userId,
    this.name,
    this.profilePic,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    userId: json["userId"],
    name: json["name"],
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "profilePic": profilePic,
  };
}

class MessagesPagination {
  int? currentPage;
  int? totalPages;
  int? totalMessages;

  MessagesPagination({
    this.currentPage,
    this.totalPages,
    this.totalMessages,
  });

  factory MessagesPagination.fromJson(Map<String, dynamic> json) => MessagesPagination(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    totalMessages: json["totalMessages"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalMessages": totalMessages,
  };
}
