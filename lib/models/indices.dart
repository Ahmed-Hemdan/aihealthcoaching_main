// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

List<IndicesModel> indicesModelFromJson(String str) => List<IndicesModel>.from(
    json.decode(str).map((x) => IndicesModel.fromJson(x)));

String indicesModelToJson(IndicesModel data) => json.encode(data.toJson());

class IndicesModel {
  IndicesModel({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory IndicesModel.fromJson(Map<String, dynamic> json) => IndicesModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}
