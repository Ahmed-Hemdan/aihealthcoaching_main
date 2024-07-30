
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  HelperApi? helperApi = new HelperApi();
  String? weight;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> submitWeight() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final auth = Provider.of<AuthProvider>(context, listen: false);

    weight = _weightController.text;
    var result = await helperApi?.addWeight(weight ?? "", auth.token ?? "");
    print(result);
    if (result == true) {
      auth.getUser(auth.token, auth.password);
      auth.initAuthProvider();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your weight was added successfully')));
      if (auth.token != null) {
        double val = 0;
        if (auth.currentWeight != "") {
          val = double.parse(auth.currentWeight ?? "");
        }
        if (val > double.parse(weight ?? "")) {
          Navigator.pushNamed(context, '/fire');
          _btnController.reset();
        } else {
          print('Val $val is less than weight $weight');
          Navigator.pop(context);
        }
      } else {
        _btnController.reset();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You have already updated the weight today.')));
    }
    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.add_weight),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _weightController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          // Allow Decimal Number With Precision of 2 Only
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
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
                          weight = value?.trim();
                          if (value?.isEmpty == true) {
                            return 'Please enter some text';
                          }
                          if (double.parse(value ?? "") <= 50) {
                            return 'The weight should be less than 50.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RoundedLoadingButton(
                        child: Text('${S.of(context)!.add_weight}',
                            style: TextStyle(color: Colors.white)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
