// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<PostModel> productFromJson(String str) => List<PostModel>.from(
    json.decode(str).map((x) => PostModel.fromJson(x)));

String productToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel({
    this.id,
    this.categoryId,
    this.indexId,
    this.title,
    this.description,
    this.link,
    this.image,
    this.file,
    this.video,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? categoryId;
  String? indexId;
  String? title;
  String? description;
  dynamic link;
  String? image;
  String? file;
  dynamic video;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"] == null ? null : json["id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    indexId: json["index_id"] == null ? null : json["index_id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    link: json["link"],
    image: json["image"] == null ? null : json["image"],
    file: json["file"] == null ? null : json["file"],
    video: json["video"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "category_id": categoryId == null ? null : categoryId,
    "index_id": indexId == null ? null : indexId,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "link": link,
    "image": image == null ? null : image,
    "file": file == null ? null : file,
    "video": video,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}