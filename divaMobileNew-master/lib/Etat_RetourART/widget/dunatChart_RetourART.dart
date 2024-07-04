import 'dart:convert';
import 'dart:io';

import '../../My_globals.dart';
import '../../colorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';


import '../../../Api.dart';
import '../../../Utils.dart';
import '../../Models/M_RetourART.dart';


class dunatChart_RetourART extends StatefulWidget {
  String date_debut;
  String date_fin;


  dunatChart_RetourART({Key? key,  required this.date_debut,required this.date_fin})
      : super(key: key);

  _HomePageS createState() => _HomePageS();
}

class _HomePageS extends State<dunatChart_RetourART> {


  late List<ChartData> chartData;



  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();
  var loading = false;


  Future _generateData() async {





    var piedata = [

      ChartData( list_RetourART[0].REF.trimRight(), double.parse(list_RetourART[0].QTE), AppColors.deepLimeGreen),


    ];
    if(list_RetourART.length >1){
      piedata.add(ChartData(list_RetourART[1].REF.trimRight(), double.parse(list_RetourART[1].QTE),AppColors.pinkShade3 ));


    }
    if(list_RetourART.length >2){
      piedata.add(ChartData(list_RetourART[2].REF.trimRight(), double.parse(list_RetourART[2].QTE), AppColors.lightGreenShade1));
    }

    if(list_RetourART.length >3){
      piedata.add(ChartData(list_RetourART[3].REF.trimRight(), double.parse(list_RetourART[3].QTE), AppColors.pinkShade2));
    }

    if(list_RetourART.length >4){
      piedata.add(ChartData(list_RetourART[4].REF.trimRight(), double.parse(list_RetourART[4].QTE), AppColors.StatBlue_light1));
    }
    if(list_RetourART.length >5){
      piedata.add(ChartData(list_RetourART[5].REF.trimRight(), double.parse(list_RetourART[5].QTE), AppColors.StatBlue_light2));
    }
    if(list_RetourART.length >6){
      piedata.add(ChartData(list_RetourART[5].REF.trimRight(), double.parse(list_RetourART[5].QTE), AppColors.violetShade3));
    }
    if(list_RetourART.length >7){
      piedata.add(ChartData(list_RetourART[5].REF.trimRight(), double.parse(list_RetourART[5].QTE), AppColors.violetShade2));
    }
    if(list_RetourART.length >8){
      piedata.add(ChartData(list_RetourART[5].REF.trimRight(), double.parse(list_RetourART[5].QTE), AppColors.orange));
    }
    if(list_RetourART.length >9){
      piedata.add(ChartData(list_RetourART[5].REF.trimRight(), double.parse(list_RetourART[5].QTE), AppColors.orangeShade7));
    }


    chartData = piedata;
    // _seriesPieData.add(
    //   charts.Series(
    //
    //     domainFn: (Task task, _) => task.task,
    //     measureFn: (Task task, _) => task.taskvalue,
    //     colorFn: (Task task, _) =>
    //         charts.ColorUtil.fromDartColor(task.colorval),
    //     id: 'Air Pollution',
    //     data: piedata,
    //
    //     labelAccessorFn: (Task row, _) => '${row.taskvalue}',
    //   ),
    // );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRetourART();


  }

  @override
  Widget build(BuildContext context) {

    return Container(

        constraints: BoxConstraints(
            minHeight: 100,  maxHeight: 330.h),

        child:  RefreshIndicator(
          onRefresh: getRetourART,
          key: _refresh,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              :list_RetourART.length<1 ?Container(): Center(
              child: Container(
                  child: Column(
                    children: [

                      SizedBox(height: 10,),
                      Expanded(
                        child: SfCircularChart(
                            margin: EdgeInsets.zero,
                            legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                              //fontSize: 15,

                            ),
                            series: <CircularSeries>[
                              // Renders doughnut chart
                              PieSeries<ChartData, String>(
                                dataSource: chartData,
                                pointColorMapper:(ChartData data,  _) => data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelMapper: (ChartData data, _) =>
                                "${data.y}",
                                explode: true,


                                //  explode: true,
                                // First segment will be exploded on initial rendering
                                explodeIndex: 1,
                                // Starting angle of doughnut
                                // startAngle: 100,
                                // // Ending angle of doughnut
                                // endAngle: 100,
                                dataLabelSettings:const DataLabelSettings(isVisible:true,
                                    labelIntersectAction: LabelIntersectAction.shift,
                                    labelPosition: ChartDataLabelPosition.inside,
                                    useSeriesColor: true,
                                    // connectorLineSettings: ConnectorLineSettings(
                                    //     type: ConnectorType.curve, length: '25%')
                                ),
                              )
                            ]
                        ),
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }

  List<M_RetourART> list_RetourART = [] ;

  ///******************************************************************* get type maintenance curatif preventif  ****************************************/

  Future<void> getRetourART() async {
    setState(() {
      loading = true;
    });

    String myUrl = BaseUrl.getRetour_ART_Entete;
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
        print(response.body);
        final data = jsonDecode(response.body) as List<dynamic>;
        list_RetourART = data.map((json) => M_RetourART.fromJson(json)).toList();

        setState(() {
          loading = false;
          _generateData();
        });

      }
    });
  }


}
class ChartData {
  ChartData(this.x, this.y, this.color,);
  final String x;

  final double y;
  final Color color;



}
