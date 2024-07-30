import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../common/config.dart';

class UserProvider with ChangeNotifier {
  int? _milestone;

  int? get milestone => _milestone;

  Future<bool> getUserData(String token) async {
    final url = Config.url + Config.user;
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);

      if (apiResponse['code'] == 200) {
        _milestone = apiResponse['user']['milestone_counters'];
        await storeUserData(apiResponse);
        notifyListeners();
        return true;
      } else {
        _milestone = 0;
        notifyListeners();
        return false;
      }
    }

    if (response.statusCode == 401) {
      notifyListeners();
      return false;
    }

    notifyListeners();
    return false;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt(
        'milestone_counters', apiResponse['user']['milestone_counters']);
  }
}
