import 'dart:convert';


import 'package:aihealthcoaching_main/common/config.dart';
import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupResults extends StatefulWidget {
  const GroupResults({Key? key}) : super(key: key);

  @override
  _GroupResultsState createState() => _GroupResultsState();
}

class _GroupResultsState extends State<GroupResults> {
  double avg = 0;
  double flagSum = 0;
  double columnFonts = 80;

  var f = NumberFormat("###.0#", "en_US");

  Future<List<NameData>> generateList() async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    final url = Config.url + Config.groupResults;
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.token}',
    });
    if (response.statusCode == 200) {
      var list = await json.decode(response.body);
      var users = list['users'] == null
          ? []
          : list['users'].cast<Map<String, dynamic>>();
      avg = double.parse(list['avg'].toString());

      List<NameData> groupList =
          await users.map<NameData>((json) => NameData.fromJson(json)).toList();
      groupList
          .sort((a, b) => -a.weightPercentage!.compareTo(b.weightPercentage ?? 0.0));

      double revenueSum = 0;
      flagSum = 0;
      groupList.forEach((item) {
        revenueSum += double.parse(item.totalLoss.toString());
        flagSum += double.parse(item.flag.toString());
      });

      double avarageWeightLoss = revenueSum / groupList.length;
      groupList.add(NameData(
        name: "Score",
        weightPercentage: avg,
        totalLoss: avarageWeightLoss.toStringAsFixed(2),
        flag: flagSum,
      ));

      return groupList;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    generateList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.group_result),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              child: FutureBuilder<List<NameData>>(
            future: generateList(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: DataTable(
                        dataRowHeight: 150,
                        headingRowHeight: 150,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: columnFonts),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Percentage Loss',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: columnFonts),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Weight Loss',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: columnFonts),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Flag',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: columnFonts),
                            ),
                          ),
                        ],
                        rows: snapShot.data!.map<DataRow>((e) {
                          bool isbold = e.name == "Score";
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Text(
                                  '${e.name}',
                                  style: isbold
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: columnFonts)
                                      : TextStyle(fontSize: columnFonts),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${(e.weightPercentage ?? 0.0 ).toStringAsFixed(2)} %',
                                  style: isbold
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: columnFonts)
                                      : TextStyle(fontSize: columnFonts),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${e.totalLoss}',
                                  style: isbold
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: columnFonts)
                                      : TextStyle(fontSize: columnFonts),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e.flag == -1 ? "" : '${e.flag}',
                                  style: isbold
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: columnFonts)
                                      : TextStyle(fontSize: columnFonts),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
        ),
      ),
    );
  }
}

class NameData {
  String? name;
  double? weightPercentage;
  dynamic weightPercentageNumber;
  String? totalLoss;
  double? flag;
  int? goldTrophy;
  int? silverTrophy;
  int? bronzeTrophy;
  int? milestoneCounters;

  NameData({
    required this.name,
    this.weightPercentage,
    this.weightPercentageNumber,
    this.totalLoss,
    this.flag,
    this.goldTrophy,
    this.silverTrophy,
    this.bronzeTrophy,
    this.milestoneCounters,
  });

  factory NameData.fromJson(Map<String, dynamic> json) {
    return NameData(
        name: json['name'],
        weightPercentage: double.parse(json['weight_percentage']),
        weightPercentageNumber: json['weight_percentage'],
        flag: double.parse(json['flag2'].toString()),
        totalLoss: json['total_loss'],
        //totalLoss: json['total_loss'],
        goldTrophy: json['gold_trophy'],
        silverTrophy: json['silver_trophy'],
        bronzeTrophy: json['bronze_trophy'],
        milestoneCounters: json['milestone_counters']);
  }
}
