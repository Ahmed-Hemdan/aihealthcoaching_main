import 'dart:convert';

import 'package:aihealthcoaching_main/common/config.dart';
import 'package:aihealthcoaching_main/models/UserWeightModel.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
    late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
    List<UserWeightModel> chartData = [];
    @override
  void initState() {
        _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: true,
        enableDoubleTapZooming: true);
      setState(() {
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
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *0.5,
                  width: double.infinity,
                  child:
                   SfCartesianChart(
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
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
