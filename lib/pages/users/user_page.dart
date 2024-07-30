import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/users/login_page.dart';
import '../../models/init_model.dart';
import '../../generated/l10n.dart';
import '../../providers/auth.dart';
import '../../animations/slide_left.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String email;
  _getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context)!.settings),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<InitModel>(builder: (context, theme, child) {
                        return ListTile(
                          leading: theme.darkMode == false
                              ? Icon(Icons.wb_sunny_outlined)
                              : Icon(Icons.nightlight_round),
                          onTap: () {
                            theme.toggleChangeTheme();
                          },
                          title: Text('${S.of(context)!.darkMode}'),
                          trailing: Switch(
                            value: theme.darkMode,
                            onChanged: (val) {
                              theme.toggleChangeTheme();
                            },
                          ),
                        );
                      }),
                      ListTile(
                        leading: Icon(Icons.language_outlined),
                        onTap: () {
                          Navigator.pushNamed(context, '/languages');
                        },
                        title: Text('${S.of(context)!.languages}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.note_outlined),
                      //   onTap: () {
                      //     Navigator.pushNamed(context, '/privacy');
                      //   },
                      //   title: Text('${S.of(context).privacy}'),
                      //   trailing: Icon(Icons.arrow_forward_ios),
                      // ),
                      // ListTile(
                      //   leading: Icon(Icons.info_outline),
                      //   onTap: () {
                      //     Navigator.pushNamed(context, '/about-us');
                      //   },
                      //   title: Text('${S.of(context).aboutUs}'),
                      //   trailing: Icon(Icons.arrow_forward_ios),
                      // ),
                      user.status == Status.Authenticated
                          ? ListTile(
                              leading: Icon(Icons.logout),
                              onTap: () {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .logOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (route) => false);
                              },
                              title: Text('${S.of(context)!.logout}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            )
                          : ListTile(
                              leading: Icon(Icons.login_outlined),
                              onTap: () {
                                Navigator.of(context)
                                    .push(SlideLeft(page: LoginScreen()));
                              },
                              title: Text('${S.of(context)!.login}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Version: 1.0.7",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
