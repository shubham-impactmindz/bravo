// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:bravo/app/modules/models/event_model.dart';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  bool? status;
  List<Notifications>? notifications;
  int? unreadCount;
  Pagination? pagination;

  NotificationListModel({
    this.status,
    this.notifications,
    this.unreadCount,
    this.pagination,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json["status"],
    notifications: json["notifications"] == null ? [] : List<Notifications>.from(json["notifications"]!.map((x) => Notifications.fromJson(x))),
    unreadCount: json["unread_count"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "unread_count": unreadCount,
    "pagination": pagination?.toJson(),
  };
}

class Notifications {
  String? notificationId;
  String? type;
  String? content;
  String? isRead;
  String? deviceTime;
  bool? isValid;
  Receiver? sender;
  Receiver? receiver;
  Group? group;
  Event? event;

  Notifications({
    this.notificationId,
    this.type,
    this.content,
    this.isRead,
    this.deviceTime,
    this.isValid,
    this.sender,
    this.receiver,
    this.group,
    this.event,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    notificationId: json["notification_id"],
    type: json["type"],
    content: json["content"],
    isRead: json["is_read"],
    deviceTime: json["device_time"],
    isValid: json["is_valid"],
    sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
    receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
    group: json["group"] == null ? null : Group.fromJson(json["group"]),
    event: json["event"] == null ? null : Event.fromJson(json["event"]),
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "type": type,
    "content": content,
    "is_read": isRead,
    "device_time": deviceTime,
    "is_valid": isValid,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "group": group?.toJson(),
    "event": event,
  };
}

class Group {
  String? id;
  String? name;
  String? groupPicture;

  Group({
    this.id,
    this.name,
    this.groupPicture,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
    groupPicture: json["group_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "group_picture": groupPicture,
  };
}

class Receiver {
  String? id;
  String? name;
  String? profilePicture;

  Receiver({
    this.id,
    this.name,
    this.profilePicture,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json["id"],
    name: json["name"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_picture": profilePicture,
  };
}

class Pagination {
  int? totalNotifications;
  int? totalPages;
  int? currentPage;
  int? limit;

  Pagination({
    this.totalNotifications,
    this.totalPages,
    this.currentPage,
    this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalNotifications: json["total_notifications"],
    totalPages: json["total_pages"],
    currentPage: json["current_page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total_notifications": totalNotifications,
    "total_pages": totalPages,
    "current_page": currentPage,
    "limit": limit,
  };
}
