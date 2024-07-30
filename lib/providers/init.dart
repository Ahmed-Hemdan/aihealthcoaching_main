import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../common/config.dart';

class InitProvider with ChangeNotifier {
  String? _one;
  String? _two;
  String? _three;

  String? get one => _one;
  String? get two => _two;
  String? get three => _three;

  Future<bool> getTrophy(int? id, String? token) async {
    final url = Config.url + Config.trophy + "/" + id.toString();
    final response = await http.get(
      Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);

      if (apiResponse['code'] == 200) {
        _one = apiResponse['trophy']['one'];
        //print(_one);
        _two = apiResponse['trophy']['two'];
        //print(_two);
        _three = apiResponse['trophy']['three'];
        //print(_three);
        await storeUserData(apiResponse);
        notifyListeners();
        return true;
      } else {
        _one = null;
        _three = null;
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
    await storage.setString('one', apiResponse['trophy']['one']);
    await storage.setString('two', apiResponse['trophy']['two']);
    await storage.setString('three', apiResponse['trophy']['three']);
  }
}
