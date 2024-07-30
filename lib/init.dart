import 'dart:async';

import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/models/init_model.dart';
import 'package:aihealthcoaching_main/pages/FireScreen.dart';
import 'package:aihealthcoaching_main/pages/categories/search_index.dart';
import 'package:aihealthcoaching_main/pages/group_result.dart';
import 'package:aihealthcoaching_main/pages/home/splash_screen.dart';
import 'package:aihealthcoaching_main/pages/home_page.dart';
import 'package:aihealthcoaching_main/pages/languages/language.dart';
import 'package:aihealthcoaching_main/pages/settings/aboutus.dart';
import 'package:aihealthcoaching_main/pages/settings/payment_screen.dart';
import 'package:aihealthcoaching_main/pages/settings/privacy.dart';
import 'package:aihealthcoaching_main/pages/settings/share.dart';
import 'package:aihealthcoaching_main/pages/users/forget_password.dart';
import 'package:aihealthcoaching_main/pages/users/login_page.dart';
import 'package:aihealthcoaching_main/pages/users/profile.dart';
import 'package:aihealthcoaching_main/pages/users/user_page.dart';
import 'package:aihealthcoaching_main/pages/weight/add_picture.dart';
import 'package:aihealthcoaching_main/pages/weight/next_goal.dart';
import 'package:aihealthcoaching_main/pages/weight/weight_screen.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:aihealthcoaching_main/providers/init.dart';
import 'package:aihealthcoaching_main/providers/user.dart';
import 'package:aihealthcoaching_main/utils/connectivity_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class ConnectivityService {
  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
  StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Changed Stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need to
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third-party enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}

class InitApp extends StatefulWidget {
  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {}); // Trigger a rebuild once sharedPreferences is initialized
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InitModel>(
      create: (context) => InitModel(),
      child: Consumer<InitModel>(
        builder: (context, value, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => InitProvider()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
            ],
            child: StreamProvider<ConnectivityStatus>(
              initialData: ConnectivityStatus.Offline, // Provide a default value
              create: (context) => ConnectivityService().connectionStatusController.stream,
              child: MaterialApp(
                theme: value.darkMode == false ? lightMode : darkMode,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  RefreshLocalizations.delegate,
                  S.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: Locale(value.locale),
                localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
                  return locale;
                },
                initialRoute: '/splash',
                routes: <String, WidgetBuilder>{
                  "/home": (context) => HomePage(),
                  "/init": (context) => InitApp(),
                  "/splash": (context) => Splash(),
                  "/login": (context) => LoginScreen(),
                  "/languages": (context) => Languages(),
                  '/userPage': (context) => UserPage(),
                  '/about-us': (context) => AboutUsScreen(),
                  '/privacy': (context) => PrivacyScreen(),
                  '/add-weight': (context) => WeightScreen(),
                  '/add-next-goal': (context) => NextGoalScreen(),
                  '/profile': (context) => ProfileScreen(),
                  '/payment': (context) => PaymentScreen(),
                  '/add-picture': (context) => AddPictureScreen(),
                  '/share': (context) => ShareScreen(),
                  '/fire': (context) => FireScreen(),
                  '/forget-password': (context) => ForgetPaswordScreen(),
                  '/group-results': (context) => GroupResults(),
                  '/search': (context) => SearchIndexScreen(),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class RouterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        user.initAuthProvider();
        String? token = user.token;
        bool? isSavePassword = user.savePassword;
        if (isSavePassword == false || isSavePassword == null) {
          return LoginScreen();
        } else {
          if (token == null) {
            return LoginScreen();
          } else {
            return HomePage();
          }
        }
      },
    );
  }
}
