import 'dart:convert';
import 'dart:io';

import 'package:divamobile/Api.dart';
import 'package:divamobile/My_globals.dart';
import 'package:divamobile/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';




class Barchar_ShowRoom extends StatefulWidget {
  String date_debut;
  String date_fin;


  Barchar_ShowRoom({Key? key,  required this.date_debut,required this.date_fin})
      : super(key: key);



  @override
  _Barchar_ShowRoomState createState() => _Barchar_ShowRoomState();
}

class _Barchar_ShowRoomState extends State<Barchar_ShowRoom> {
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


    String myUrl = BaseUrl.CA_getCA_ShowRoom;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {


          "date_debut":widget.date_debut,
          "date_fin"  :widget.date_fin,
          "DOS":Global.getDOS()

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<GDPData> chartData = jsonData.map((data) {
          return GDPData(data['NOM'].toString().trimRight().replaceAll("SOTUFAB DISTRIBUTION ", ""), double.parse(data['MONT'].toString()));
        }).toList();
        setState(() {
          _chartData = chartData;
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      width: 400.w,
      child: Scaffold(
        body: SfCartesianChart(
          //isTransposed: true,

          legend: Legend(isVisible: false),
          tooltipBehavior: _tooltipBehavior,
          series: <CartesianSeries>[
            BarSeries<GDPData, String>(
              name: 'Montant',
              dataSource: _chartData,
              xValueMapper: (GDPData gdp, _) => gdp.continent,
              yValueMapper: (GDPData gdp, _) => gdp.gdp,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
          primaryXAxis: CategoryAxis(
             // labelRotation: 80
          ),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            numberFormat: NumberFormat('#,###'),
            title: AxisTitle(text: 'MONT'),
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
