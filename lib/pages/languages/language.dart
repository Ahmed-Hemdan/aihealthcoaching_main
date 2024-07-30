import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/init_model.dart';

class Languages extends StatefulWidget {
  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    var initModel = Provider.of<InitModel>(
      context,
      listen: false,
    );
    List<Widget> list = [];
    List<Map<String, dynamic>> languages = getAlllanguages(context);
    for (var i = 0; i < languages.length; i++) {
      list.add(
        Card(
          elevation: 0,
          margin: EdgeInsets.all(2),
          child: ListTile(
            leading: SvgPicture.asset(
              'assets/flags/${languages[i]["image"]}.svg',
              fit: BoxFit.cover,
              width: 30,
              height: 20,
            ),
            title: Text(languages[i]["name"]),
            onTap: () async {
              await Provider.of<InitModel>(context, listen: false)
                  .changeLanguage(context, languages[i]["code"]);

              setState(() {});
            },
            trailing: initModel.locale == languages[i]["code"]
                ? Icon(
                    Icons.check_outlined,
                    color: Colors.green,
                  )
                : SizedBox(),
          ),
        ),
      );
    }
    /*return Consumer<AuthProvider>(builder: (context, user, child) {
      
    });*/
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          S.of(context)!.language,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...list,
          ],
        ),
      ),
    );
  }
}
