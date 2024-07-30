
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:aihealthcoaching_main/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String url = "https://aihealthcoaching.ca/";
  int? id;
  int referralCounter = 1;

  HelperApi helperApi = new HelperApi();

  shareBox(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    id = authProvider.id;
    String ref = url;
    //final RenderBox box = context.findRenderObject() as RenderBox;
    //Share.share('check out my website https://example.com', subject: 'Look what I made!',sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    Share.share('$ref', subject: '');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.share),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Thank you for the referral. We appreciate your support by spreading the good word.",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          S.of(context)!.share,
                          style: Styles.p.copyWith(
                            color: Colors.white,
                            height: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onPressed: () {
                        var auth =
                            Provider.of<AuthProvider>(context, listen: false);
                        helperApi.addReferral(referralCounter, auth.token ?? "");
                        shareBox(context);
                      },
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
