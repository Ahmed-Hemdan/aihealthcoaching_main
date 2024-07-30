
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgetPaswordScreen extends StatefulWidget {
  const ForgetPaswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPaswordScreenState createState() => _ForgetPaswordScreenState();
}

class _ForgetPaswordScreenState extends State<ForgetPaswordScreen> {
  final _formKey = GlobalKey<FormState>();
  HelperApi helperApi = new HelperApi();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  late String email;

  Future<void> submitWeight() async {
    final form = _formKey.currentState;
    if (form?.validate() == true) {
      helperApi.forgotPassword(email);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reset password link sent on your email id.')));
        Navigator.pushNamed(context, '/login');
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.forgetPassword),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          initialValue: 'Your email',
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            email = value!.trim();
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        /*StyledFlatButton(
                          S.of(context).sendPassword,
                          onPressed: submitWeight,
                        ),*/

                        RoundedLoadingButton(
                          child: Text('${S.of(context)!.sendPassword}', style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: submitWeight,
                          color: Colors.blue,
                          borderRadius: 5.0,
                          width: MediaQuery.of(context).size.width,
                        ),

                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
