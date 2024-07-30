
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NextGoalScreen extends StatefulWidget {
  const NextGoalScreen({Key? key}) : super(key: key);

  @override
  _NextGoalScreenState createState() => _NextGoalScreenState();
}

class _NextGoalScreenState extends State<NextGoalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HelperApi helperApi = new HelperApi();

  String? nextMilestone;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future<void> submitAddMilestone() async {
    final form = _formKey.currentState;
    if (form?.validate() == true) {
      FocusScope.of(context).requestFocus(FocusNode());

      final auth = Provider.of<AuthProvider>(context, listen: false);
      var result = await helperApi.addNextGoal(nextMilestone, auth.token ?? "");
      print(result);
      if (result == true) {
        await auth.login(auth.email ?? "", auth.password ?? "", true);
        auth.initAuthProvider();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your next goal was added successfully',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
        if (auth.token != null) {
          auth.initAuthProvider();
          await Navigator.popAndPushNamed(context, '/home');
        }
      } else {
        _btnController.reset();
      }
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.add_next_goal),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
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
                        nextMilestone = value?.trim();
                        if (value?.isEmpty == true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nextMilestone = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    /*StyledFlatButton(
                      S.of(context).add_next_goal,
                      onPressed: submitAddMilestone,
                    ),*/

                    RoundedLoadingButton(
                      child: Text('${S.of(context)!.add_next_goal}',
                          style: TextStyle(color: Colors.white)),
                      controller: _btnController,
                      onPressed: submitAddMilestone,
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
            ),
          ),
        ),
      ),
    );
  }
}
