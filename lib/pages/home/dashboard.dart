import 'dart:convert';
import 'dart:core';

import 'package:aihealthcoaching_main/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../common/config.dart';
import '../../models/UserWeightModel.dart';
import '../../providers/auth.dart';
import '../../providers/init.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/helper_api.dart';
import '../../common/constants.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  HelperApi helperApi = new HelperApi();
  var items = [];
  int page = 1;
  double offset = 0.0;
  bool isLoading = false;
  List<UserWeightModel> chartData = [];
  ScrollController _scrollController = new ScrollController();
  var fetchProducts;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  late AuthProvider auth;
  var init;
  var user;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> counterr;

  Future loadChartData() async {
    var data;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final url = Config.url + Config.charts2;
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.token}',
    });
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      final dynamic result = json.decode(response.body);
      for (Map<String, dynamic> i in result) {
        chartData.add(UserWeightModel.fromJson(i));
      }
    }

    return data;
  }

  Future<int> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0);
    return counter;
  }

  @override
  void initState() {
    //this.loadChartData();
    auth = Provider.of<AuthProvider>(context, listen: false);
    init = Provider.of<InitProvider>(context, listen: false);

    Provider.of<UserProvider>(context, listen: false).getUserData(auth.token ?? "");

    _incrementCounter();
    auth.getUser(auth.token, auth.password);
    auth.initAuthProvider();

    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: true,
        enableDoubleTapZooming: true);

    super.initState();
  }

  @override
  void dispose() {
    //_controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(kAppName),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 0.0, top: 10.0),
          child: FutureBuilder(
            future: init.getTrophy(auth.subgroupId, auth.token),
            builder: (content, snapshot) {
              if (snapshot.hasData) {
                return _trophy();
              }
              return SizedBox();
            },
          ),
        ),
        //user profile icon so we can navigate to user profile
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/userPage');
            },
            child: Image.asset(
              "assets/images/icons/account.png",
              fit: BoxFit.fitHeight,
              height: 200,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: FutureBuilder(
                future: loadChartData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    
                   return SfCartesianChart(
                      zoomPanBehavior: _zoomPanBehavior,
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: ""),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CartesianSeries<UserWeightModel, String>>[
                        LineSeries<UserWeightModel, String>(
                          dataSource: chartData,
                          xValueMapper: (UserWeightModel user, _) =>
                              user.week.substring(5),
                          yValueMapper: (UserWeightModel user, _) =>
                              user.weight,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                        ),
                      ],
                    );

                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: GridView.count(
                scrollDirection: Axis.vertical,
                childAspectRatio: 3 / 2,
                shrinkWrap: true,
                primary: false,
                mainAxisSpacing: 0,
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 3
                        : 4,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/percentage.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.weightPercentage}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/lose_weight.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.differenceLossWeight}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/milestone-2.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.milestoneCounters}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/gold_medal.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.goldTrophy}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/silver_medal.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.silverTrophy}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/bronze_medal.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.bronzeTrophy}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/target.png",
                        width: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${auth.nextGoal}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/date_to_achieve.png",
                        width: 50.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            auth.expectedDate ?? "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trophy() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var initProvider = Provider.of<InitProvider>(context, listen: false);
    if (authProvider.name == initProvider.one) {
      //print(initProvider.one);
      return Image.asset(
        "assets/images/icons/gold_cup.png",
        width: 50.0,
        height: 150.0,
      );
    } else if (authProvider.name == initProvider.two) {
      //print(initProvider.two);
      return Image.asset(
        "assets/images/icons/silver_cup.png",
        width: 50.0,
        height: 150.0,
      );
    } else if (authProvider.name == initProvider.three) {
      //print(initProvider.three);
      return SizedBox(
          child: Image.asset(
        "assets/images/icons/bronze_cup.png",
        height: 150.0,
      ));
    } else {
      return SizedBox();
    }
  }
}
