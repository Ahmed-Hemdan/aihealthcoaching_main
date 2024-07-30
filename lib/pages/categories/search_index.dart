
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'search_in_categories.dart';

class SearchIndexScreen extends StatefulWidget {
  final int? index;
  SearchIndexScreen({Key? key, this.index}) : super(key: key);

  @override
  _SearchIndexScreenState createState() => _SearchIndexScreenState();
}

class _SearchIndexScreenState extends State<SearchIndexScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HelperApi helperApi = new HelperApi();

  String? title;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Future<void> submitAddMilestone() async {
    final form = _formKey.currentState;
    if (form?.validate() == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SingleCategoryInSearch(
                    index: widget.index ?? 0,
                    title: title ?? "",
                  )));
    } else {
      _btnController.reset();
    }
  }

  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.search),
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
                        title = value?.trim();
                        if (value?.isEmpty == true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RoundedLoadingButton(
                      child: Text('${S.of(context)!.search}',
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
