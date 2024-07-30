import 'package:flutter/material.dart';
import 'config_size.dart';

const String kAppName = 'Ai Health Coaching';
const String kAppConfig = 'lib/common/config.json';
const kMainColor = 0XFFF2F2F2;
const kPrimaryNavigationBarColor = 0XFF117182;
const kPrimaryColor = 0XFFFFFFFF;
const kPrimaryColorTwo = Color(0xFFFF7643);
const APP_FOLDER = 'COOL_STORE';

// #ff6a1e Orange
// Type Logo - local | network
const String kLogoImageType = "local";
const kLogoImageLocal = "assets/images/logo2.png";
const kTextLogoInSplashScreen = false; // Show Text under Logo In Splash Screen
const kSizeLogoInSplashScreen =
200.0; // Logo Size In Splash Screen | 0.0 not Size

// Settings Image in User Settings Page
const kSettingsImage = "assets/images/logo.png";

class Constants {
  // Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.orange;
  static Color darkAccent = Colors.orangeAccent;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;

  static String searchBarTag = 'searchbartag';
  static String searchSubtitleTag = 'searchSubtitleTag';
  static String searchIconTag = 'searchIconTag';
  static double baseHeight = 640;

  static double screenAwareSize(double size, BuildContext context) {
    return size * MediaQuery.of(context).size.height / baseHeight;
  }

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: lightBG,
    primaryColor: lightPrimary,
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: lightBG,
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBG,
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: darkBG,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

List<Map<String, String>> getAlllanguages([BuildContext? context]) {
  return [
    {
      "id": "1",
      "name": "English",
      "image": "en",
      "code": "en",
    },
    {
      "id": "2",
      "name": "Arabic",
      "image": "ar",
      "code": "ar",
    },
  ];
}