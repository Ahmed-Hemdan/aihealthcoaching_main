import 'dart:async';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../providers/auth.dart';
import '../../utils/styles.dart';
import '../../utils/validate.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _keyProfileForm = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  bool hidePassword = true;
  bool loaded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  HelperApi helperApi = new HelperApi();

  Future<void> submitUpdate() async {

    final form = _keyProfileForm.currentState;
    if (form?.validate() == true) {

      Map<String, dynamic> map = {
        "name": name,
        "phone": phone,
      };

      final auth = Provider.of<AuthProvider>(context, listen: false);
      helperApi.updateProfile(map, auth.token ?? "");

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context)!.update_profile,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _btnController.reset();
    }
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    return null;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context)!.profile),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, right: 20, left: 20),
                      child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(auth.image ?? "")),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Form(
                        key: _keyProfileForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.0,
                            ),
                            TextFormField(
                              initialValue: auth.email,
                              //initialValue: auth.email,
                              decoration: Styles.input.copyWith(
                                hintText: '${S.of(context)!.email}',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              initialValue: auth.name,
                              decoration: Styles.input.copyWith(
                                hintText: '${S.of(context)!.name}',
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.blue),
                              ),
                              validator: (value) {
                                name = value?.trim() ?? "";
                                return Validate.requiredField(
                                    value ?? "", S.of(context)!.name_is_required);
                              },
                              onSaved: (String? value){
                                name = value ?? "";
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              initialValue: auth.phone,
                              decoration: Styles.input.copyWith(
                                hintText: '${S.of(context)!.email}',
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.blue),
                                //labelText: customerModel.customerDetailModel.firstName ?? 'ddd',
                              ),
                              validator: (value) {
                                phone = value?.trim() ?? "";
                                return Validate.requiredField(
                                    value ?? "", S.of(context)!.name_is_required);
                              },
                              onSaved: (String? value){
                                phone = value ?? "";
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            /*StyledFlatButton(
                              '${S.of(context).update}',
                              onPressed: () {
                                submitUpdate();
                              },
                            ),*/

                            RoundedLoadingButton(
                              child: Text('${S.of(context)!.update}', style: TextStyle(color: Colors.white)),
                              controller: _btnController,
                              onPressed: () {
                                submitUpdate();
                              },
                              color: Colors.blue,
                              borderRadius: 5.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
