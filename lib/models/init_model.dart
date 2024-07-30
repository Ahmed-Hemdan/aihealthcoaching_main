import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../common/constants.dart';

// Define the light and dark themes with correct properties
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(kPrimaryColor),
  colorScheme: ColorScheme.light(primary: Color(kPrimaryColor)),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
    selectedLabelStyle: TextStyle(
      color: Colors.white,
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    unselectedLabelStyle: TextStyle(color: Colors.white),
  ),
);

class InitModel with ChangeNotifier {
  Map<String, dynamic> appConfig = {}; // Initialize with empty map
  bool isLoading = true;
  String message = ''; // Initialize with empty string
  String _locale = 'en';
  String _currency = '\$';

  String get locale => _locale;
  String get currency => _currency;

  final String key = "theme";
  SharedPreferences? _preferences; // Use nullable type
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  InitModel() {
    _darkMode = false;
    _locale = 'en';
    _currency = '\$';
    _loadFromPreferences();
    _getLanguage();
    _getCurrency();
  }

  Future<void> _initialPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  Future<void> _savePreferences() async {
    await _initialPreferences();
    if (_preferences != null) {
      await _preferences!.setBool(key, _darkMode);
    }
  }

  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    if (_preferences != null) {
      _darkMode = _preferences!.getBool(key) ?? false;
      notifyListeners();
    }
  }

  void toggleChangeTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _getLanguage() async {
    await _initialPreferences();
    if (_preferences != null) {
      _locale = _preferences!.getString('language') ?? 'en';
      notifyListeners();
    }
  }

  Future<void> _getCurrency() async {
    await _initialPreferences();
    if (_preferences != null) {
      _currency = _preferences!.getString('currency') ?? '\$';
      notifyListeners();
    }
  }

  Future<void> changeLanguage(BuildContext context, String countryCode) async {
    await _initialPreferences();
    if (_preferences != null) {
      _locale = countryCode;
      await _preferences!.setString("language", _locale);
      notifyListeners();
    }
  }

  Future<void> changeCurrencies(BuildContext context, String currencyCode) async {
    await _initialPreferences();
    if (_preferences != null) {
      _currency = currencyCode;
      await _preferences!.setString("currency", _currency);
      notifyListeners();
    }
  }

  Future<void> loadAppConfig() async {
    try {
      if (kAppConfig.contains('http')) {
        final appJson = await http.get(Uri.parse(Uri.encodeFull(kAppConfig)),
            headers: {"Accept": "application/json"});
        appConfig = convert.jsonDecode(appJson.body);
      } else {
        final appJson = await rootBundle.loadString(kAppConfig);
        appConfig = convert.jsonDecode(appJson);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      message = e.toString();
      notifyListeners();
    }
  }
}

class App {
  Map<String, dynamic> appConfig;

  App(this.appConfig);
}