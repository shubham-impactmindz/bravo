// To parse this JSON data, do
//
//     final groupsListModel = groupsListModelFromJson(jsonString);

import 'dart:convert';

GroupsListModel groupsListModelFromJson(String str) => GroupsListModel.fromJson(json.decode(str));

String groupsListModelToJson(GroupsListModel data) => json.encode(data.toJson());

class GroupsListModel {
  bool? isSuccess;
  String? message;
  List<GroupList>? data;

  GroupsListModel({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory GroupsListModel.fromJson(Map<String, dynamic> json) => GroupsListModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? [] : List<GroupList>.from(json["data"]!.map((x) => GroupList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GroupList {
  String? groupId;
  String? name;
  String? description;
  String? createdBy;
  dynamic parentGroupId;
  String? groupPicture;
  String? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  GroupList({
    this.groupId,
    this.name,
    this.description,
    this.createdBy,
    this.parentGroupId,
    this.groupPicture,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupList.fromJson(Map<String, dynamic> json) => GroupList(
    groupId: json["group_id"],
    name: json["name"],
    description: json["description"],
    createdBy: json["created_by"],
    parentGroupId: json["parent_group_id"],
    groupPicture: json["group_picture"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "name": name,
    "description": description,
    "created_by": createdBy,
    "parent_group_id": parentGroupId,
    "group_picture": groupPicture,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
