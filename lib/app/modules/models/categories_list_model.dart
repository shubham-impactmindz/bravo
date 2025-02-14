// To parse this JSON data, do
//
//     final categoriesListModel = categoriesListModelFromJson(jsonString);

import 'dart:convert';

CategoriesListModel categoriesListModelFromJson(String str) => CategoriesListModel.fromJson(json.decode(str));

String categoriesListModelToJson(CategoriesListModel data) => json.encode(data.toJson());

class CategoriesListModel {
  bool? isSuccess;
  String? message;
  List<CategoryList>? data;

  CategoriesListModel({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory CategoriesListModel.fromJson(Map<String, dynamic> json) => CategoriesListModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CategoryList>.from(json["data"]!.map((x) => CategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CategoryList {
  String? catId;
  String? catName;
  String? status;
  DateTime? createAt;

  CategoryList({
    this.catId,
    this.catName,
    this.status,
    this.createAt,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    catId: json["cat_id"],
    catName: json["cat_name"],
    status: json["status"],
    createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
  );

  Map<String, dynamic> toJson() => {
    "cat_id": catId,
    "cat_name": catName,
    "status": status,
    "create_at": createAt?.toIso8601String(),
  };
}
