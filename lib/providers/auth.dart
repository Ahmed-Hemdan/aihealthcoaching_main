import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../common/config.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  String? _token;
  String? _email;
  String? _password;
  String? _name;
  int? _id;
  String? _weightPercentage;
  int? _goldTrophy;
  int? _silverTrophy;
  int? _bronzeTrophy;
  String? _nextGoal;
  int? _milestoneCounters;
  int? _categoryId;
  int? _subgroupId;
  String? _image;
  String? _phone;
  String? _city;
  String? _differenceLossWeight;
  String? _expectedDate;
  String? _book;
  String? _currentWeight;
  bool? _savePassword = false;

  Status get status => _status;
  String? get token => _token;
  String? get email => _email;
  String? get password => _password;
  String? get name => _name;
  int? get id => _id;
  String? get weightPercentage => _weightPercentage;
  int? get goldTrophy => _goldTrophy;
  int? get silverTrophy => _silverTrophy;
  int? get bronzeTrophy => _bronzeTrophy;
  String? get nextGoal => _nextGoal;
  int? get milestoneCounters => _milestoneCounters;
  int? get categoryId => _categoryId;
  int? get subgroupId => _subgroupId;
  String? get image => _image;
  String? get phone => _phone;
  String? get city => _city;
  String? get differenceLossWeight => _differenceLossWeight;
  String? get expectedDate => _expectedDate;
  String? get book => _book;
  String? get currentWeight => _currentWeight;
  bool? get savePassword => _savePassword;

  BuildContext? context;

  initAuthProvider() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await getToken();
    //getUser(token);
    if (token != null || sharedPreferences.getString('token') != null) {
      _token = token;
      _email = sharedPreferences.getString('email');
      _password = sharedPreferences.getString('password');
      _name = sharedPreferences.getString('name');
      _id = sharedPreferences.getInt('id');
      _weightPercentage = sharedPreferences.getString('weight_percentage');
      _goldTrophy = sharedPreferences.getInt('gold_trophy');
      _silverTrophy = sharedPreferences.getInt('silver_trophy');
      _bronzeTrophy = sharedPreferences.getInt('bronze_trophy');
      _nextGoal = sharedPreferences.getString('next_goal');
      _milestoneCounters = sharedPreferences.getInt('milestone_counters');
      _categoryId = sharedPreferences.getInt('category_id');
      _subgroupId = sharedPreferences.getInt('subgroup_id');
      _image = sharedPreferences.getString('image');
      _phone = sharedPreferences.getString('phone');
      _city = sharedPreferences.getString('city');
      _differenceLossWeight =
          sharedPreferences.getString('differenceLossWeight');
      _expectedDate = sharedPreferences.getString('expectedDate');
      _book = sharedPreferences.getString('book');
      _currentWeight = sharedPreferences.getString('current_weight');
      _savePassword = sharedPreferences.getBool('savePassword');
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
      _token = null;
      _email = null;
      _password = null;
      _name = null;
      _id = null;
      _weightPercentage = null;
      _goldTrophy = null;
      _silverTrophy = null;
      _bronzeTrophy = null;
      _nextGoal = null;
      _milestoneCounters = null;
      _categoryId = null;
      _subgroupId = null;
      _image = null;
      _phone = null;
      _city = null;
      _differenceLossWeight = null;
      _book = null;
      _expectedDate = null;
      _currentWeight = null;
      _savePassword = false;
    }
    notifyListeners();
    return _status;
  }

  Future<bool> login(String email, String password, bool savePassword) async {
    final url = Config.url + Config.login;

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      if (apiResponse['code'] == 200) {
        _status = Status.Authenticated;
        _password = password;
        _token = apiResponse['user']['token'];
        //print(_token);
        _id = apiResponse['user']['id'];
        _email = apiResponse['user']['email'];
        //print(_email);
        _name = apiResponse['user']['name'];
        _categoryId = apiResponse['user']['category_id'];
        //print(_name);
        _subgroupId = apiResponse['user']['subgroup_id'];
        _image = apiResponse['user']['image'];
        _phone = apiResponse['user']['phone'];
        _city = apiResponse['user']['city'];
        _weightPercentage = apiResponse['user']['weight_percentage'];
        _goldTrophy = apiResponse['user']['gold_trophy'];
        _silverTrophy = apiResponse['user']['silver_trophy'];
        _bronzeTrophy = apiResponse['user']['bronze_trophy'];
        _milestoneCounters = apiResponse['user']['milestone_counters'];
        _nextGoal = apiResponse['user']['next_goal'].toString();
        _differenceLossWeight = apiResponse['user']['differenceLossWeight'];
        _expectedDate = apiResponse['user']['expectedDate'];
        _book = apiResponse['user']['book'];
        _currentWeight = apiResponse['user']['current_weight'].toString();
        _savePassword = savePassword;
        await storeUserData(apiResponse, _password, _savePassword);
        notifyListeners();
        return true;
      } else {
        _status = Status.Unauthenticated;
        _token = null;
        _email = null;
        _name = null;
        _id = null;
        _categoryId = null;
        _subgroupId = null;
        _image = null;
        _phone = null;
        _city = null;
        _weightPercentage = null;
        _goldTrophy = null;
        _silverTrophy = null;
        _bronzeTrophy = null;
        _milestoneCounters = null;
        _nextGoal = null;
        _differenceLossWeight = null;
        _expectedDate = null;
        _book = null;
        _currentWeight = null;
        _savePassword = false;
        notifyListeners();
        return false;
      }
    }

    if (response.statusCode == 401) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }

    _status = Status.Unauthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> getUser(String? token, String? password) async {
    final url = Config.url + Config.user;
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      print(_nextGoal);
      if (apiResponse['code'] == 200) {
        _savePassword = savePassword;
        await storeUserData(apiResponse, password, _savePassword);
        _token = apiResponse['user']['token'];

        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  storeUserData(apiResponse, String? password, bool? savePassword) async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.setString('password', password ?? "");
    await storage.setString('token', apiResponse['user']['token']);
    await storage.setString('email', apiResponse['user']['email']);
    await storage.setString('name', apiResponse['user']['name']);
    await storage.setInt('category_id', apiResponse['user']['category_id']);
    await storage.setInt('subgroup_id', apiResponse['user']['subgroup_id']);
    await storage.setString('image', apiResponse['user']['image'] ?? "");
    await storage.setString('phone', apiResponse['user']['phone'] ?? "");
    await storage.setString('city', apiResponse['user']['city'] ?? "");

    await storage.setInt('id', apiResponse['user']['id']);
    await storage.setString(
        'weight_percentage', apiResponse['user']['weight_percentage'] ?? "");
    await storage.setInt(
        'gold_trophy', apiResponse['user']['gold_trophy'] ?? "");
    await storage.setInt(
        'silver_trophy', apiResponse['user']['silver_trophy'] ?? "");
    await storage.setInt(
        'bronze_trophy', apiResponse['user']['bronze_trophy'] ?? "");
    await storage.setInt(
        'milestone_counters', apiResponse['user']['milestone_counters'] ?? "");
    await storage.setString(
        'current_weight', apiResponse['user']['current_weight'].toString());
    await storage.setString(
        'next_goal', apiResponse['user']['next_goal'].toString());
    await storage.setString('differenceLossWeight',
        apiResponse['user']['differenceLossWeight'] ?? "");
    await storage.setString(
        'expectedDate', apiResponse['user']['expectedDate'] ?? "");
    await storage.setString('book', apiResponse['user']['book']);
    await storage.setBool('savePassword', savePassword ?? false);
  }

  updateKey(String key, String value) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString(key, value);
  }

  getKeyValue(String key) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString(key);
    return token ?? "";
  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');
    return token ?? "";
  }

  Future<String> getEmail() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? email = storage.getString('email');
    return email ?? "";
  }

  Future<String> getFirstName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? firstName = storage.getString('firstName');
    return firstName ?? "";
  }

  Future<String> getLastName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? lastName = storage.getString('lastName');
    return lastName ?? "";
  }

  Future<String> getID() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? id = storage.getString('id');
    return id ?? "";
  }

  logOut([bool tokenExpired = false]) async {
    final url = Config.url + Config.logout;
    await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    _status = Status.Unauthenticated;
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
