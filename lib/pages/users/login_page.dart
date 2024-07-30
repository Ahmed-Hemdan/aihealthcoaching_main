import 'dart:async';

import 'package:aihealthcoaching_main/providers/init.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../generated/l10n.dart';
import '../../providers/auth.dart';
import '../../common/constants.dart';
import '../../utils/styles.dart';
import '../../utils/validate.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _keyLoginForm = GlobalKey<FormState>();

  String username = '';
  String password = '';
  String messages = '';
  bool hidePassword = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool valuefirst = false;
  bool valuesecond = false;

  Future<void> submitLogin() async {
    final form = _keyLoginForm.currentState;
    if (form?.validate() == true) {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(username, password, this.valuefirst);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null) {
        var init = Provider.of<InitProvider>(context, listen: false);
        init.getTrophy(auth.subgroupId, auth.token);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        _btnController.reset();
        _showError();
      }
    } else {
      _btnController.reset();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 68.0,
        child: Image.asset(
          kLogoImageLocal,
          fit: BoxFit.contain,
        ),
      ),
    );

    return RefreshIndicator(
      child: Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            S.of(context)!.login,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _keyLoginForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      logo,
                      SizedBox(
                        height: 50.0,
                      ),
                      TextFormField(
                        decoration: Styles.input.copyWith(
                          hintText: '${S.of(context)!.email}',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[700],
                          ),
                        ),
                        validator: (value) {
                          username = value?.trim() ?? "";
                          return Validate.validateEmail(
                              value ?? "",
                              S.of(context)!.email_is_required,
                              S.of(context)!.email_is_valid);
                        },
                        onSaved: (String? value) {
                          username = value ?? "";
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: hidePassword,
                        decoration: Styles.input.copyWith(
                          hintText: '${S.of(context)!.password}',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[700],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          password = value?.trim() ?? "";
                          return Validate.requiredField(
                              value ?? "", '${S.of(context)!.password_is_required}');
                        },
                        onSaved: (String? value) {
                          password = value ?? "";
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.blue,
                                value: this.valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.valuefirst = value ?? false;
                                  });
                                  //print(this.valuefirst);
                                },
                              ),
                              Text(
                                'Remember me ',
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RoundedLoadingButton(
                        child: Text('${S.of(context)!.login}',
                            style: TextStyle(color: Colors.white)),
                        controller: _btnController,
                        onPressed: submitLogin,
                        color: Colors.blue,
                        borderRadius: 5.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: ' ${S.of(context)!.forgetPassword}',
                                style:
                                    Styles.p.copyWith(color: Color(0xff000000)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => 
                                        Navigator.pushNamed(
                                            context, '/forget-password'),
                                      ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onRefresh: _refreshhandle,
    );
  }

  Future<Null> _refreshhandle() async {
    setState(() {});
    _btnController.reset();
    return null;
  }

  _showError() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(S.of(context)!.error_dialog),
              content: new Text(S.of(context)!.error_dialog),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    S.of(context)!.close,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
    return Container();
  }
}
