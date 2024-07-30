class LoginModel {
  String? title;

  LoginModel({
    this.title,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      title: json['title'],
    );
  }
}
