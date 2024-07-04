
import 'dart:convert';
import 'dart:io';

import '../../constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../Models/M_Stock.dart';
import '../../My_globals.dart';
import '../../colorApp.dart';
import '../../responsive.dart';
import 'package:http/http.dart' as http;
import '../../Api.dart';
import '../../Utils.dart';

class BarChartSample7 extends StatefulWidget {


  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  final pilateColor = AppColors.purple;

  final cyclingColor = AppColors.yellow;

  final quickWorkoutColor = AppColors.green;

  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
      int x,
      //double pilates,
      double quickWorkout,
     // double cycling,
      ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        // BarChartRodData(
        //   fromY: 0,
        //   toY: pilates,
        //   color: pilateColor,
        //   width: 5,
        // ),
        BarChartRodData(
          fromY: 0,
          toY:  quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
        // BarChartRodData(
        //   fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
        //   toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
        //   color: cyclingColor,
        //   width: 5,
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from the API when the widget initializes
  }
  bool loading = false;

  List<M_Stock> Stock_list = [] ;

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    String myUrl = BaseUrl.get_Stock;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {
          "DOS":Global.getDOS(),
          "NB":Global.NB_stock.toString(),
          "USIM_TYPFAM":Global.getFamART_Stat().toString(),

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        var jsonData = jsonDecode(response.body);
        final data = jsonDecode(response.body);
        data.forEach((api) {


          final ab =  M_Stock(

            api['REF'].toString().trimRight() ,
            api['DES'].toString().trimRight(),
            double.parse(api['QTE'].toString()) ,
            int.parse(api['NB'].toString()) ,

          );
          Stock_list.add(ab);


        });

        setState(() {
          loading = false;

        });
      }
    });
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text = "";


      text = Stock_list[int.parse(double.parse((value-1).toString()).toStringAsFixed(0))].REF;
    

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quantité par article',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          AspectRatio(
            aspectRatio: ResponsiveWidget.isSmallScreen(context) ? 2 : 4,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles:SideTitles(
                      showTitles: false,)
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(

                      //  rotateAngle: 90,
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: true,),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: List.generate(
                  Stock_list.length,
                      (index) => generateGroupData(Stock_list[index].NB, Stock_list[index].QTE),
                ),
                maxY: 2000 ,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 3.3,
                      color: pilateColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 8,
                      color: quickWorkoutColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 11,
                      color: cyclingColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}