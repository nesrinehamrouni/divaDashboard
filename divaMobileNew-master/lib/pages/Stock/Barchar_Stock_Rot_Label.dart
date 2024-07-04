import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../Utils.dart';



class Barchar_Stock_Rot_Label extends StatefulWidget {

  String REF;
  Barchar_Stock_Rot_Label({Key? key, required this.REF}): super(key:key);




  @override
  _Barchar_Stock_Rot_LabelState createState() => _Barchar_Stock_Rot_LabelState();
}

class _Barchar_Stock_Rot_LabelState extends State<Barchar_Stock_Rot_Label> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = [];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _fetchChartData();
    super.initState();
  }

  void _fetchChartData() async {
   String myUrl = BaseUrl.get_Stock;
   final response =   http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {
          "DOS":Global.getDOS(),
          "Depot":Global.getDepot_Stat(),
          "NB":Global.NB_stock.toString(),
          "REFART":widget.REF,
          "USIM_TYPFAM":Global.getFamART_Stat().toString(),

        }).then((response) {
     if (response.statusCode == 200) {
       final List<dynamic> jsonData = json.decode(response.body);
       final List<GDPData> chartData = jsonData.map((data) {
         return GDPData(data['REF'], data['QTE'].toDouble());
       }).toList();
       setState(() {
         _chartData = chartData;
       });
     } else {
       throw Exception('Failed to fetch chart data');
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          isTransposed: true,
          title: ChartTitle(text: 'Article par quantité'),
          legend: Legend(isVisible: false),
          tooltipBehavior: _tooltipBehavior,
          series: <CartesianSeries>[
            BarSeries<GDPData, String>(
              name: 'gdp',
              dataSource: _chartData,
              xValueMapper: (GDPData gdp, _) => gdp.continent,
              yValueMapper: (GDPData gdp, _) => gdp.gdp,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
          primaryXAxis: CategoryAxis(labelRotation: 45),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat('#,###'),
            title: AxisTitle(text: 'QTE'),
          ),
        ),
      ),
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);

  final String continent;
  final double gdp;
}
