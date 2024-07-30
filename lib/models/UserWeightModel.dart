class UserWeightModel {
  UserWeightModel(this.week, this.weight);
  final String week;
  final double weight;

  factory UserWeightModel.fromJson(Map<String, dynamic> json) {
    return UserWeightModel(
      json['week'].toString(),
      json['weight'].toDouble(),
    );
  }
}