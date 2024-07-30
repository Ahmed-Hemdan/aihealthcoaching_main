// To parse this JSON data, do
//
//     final userWeight = userWeightFromJson(jsonString);

import 'dart:convert';

List<UserWeight> userWeightFromJson(String str) => List<UserWeight>.from(json.decode(str).map((x) => UserWeight.fromJson(x)));

String userWeightToJson(List<UserWeight> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserWeight {
  UserWeight({
    this.weight,
    this.week,
  });

  double? weight;
  DateTime? week;

  factory UserWeight.fromJson(Map<String, dynamic> json) => UserWeight(
    weight: json["weight"] == null ? null : json["weight"].toDouble(),
    week: json["week"] == null ? null : DateTime.parse(json["week"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight == null ? null : weight,
    "week": week == null ? null : "${week?.year.toString().padLeft(4, '0')}-${week?.month.toString().padLeft(2, '0')}-${week?.day.toString().padLeft(2, '0')}",
  };
}
