import 'dart:convert';
import 'dart:io';
import '../../../My_globals.dart';
import '../../../colorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Api.dart';
import '../../../Models/M_ChiffreAffaire.dart';
import '../../../Utils.dart';


class dunatChart_CLI_MONT extends StatefulWidget {


  _HomePageS createState() => _HomePageS();
}

class _HomePageS extends State<dunatChart_CLI_MONT> {


  late List<ChartData> chartData;



  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();
  var loading = false;


  Future _generateData() async {





    var piedata = [

      ChartData( list_ChiffreAffaire[0].NOM!.trimRight(), double.parse(list_ChiffreAffaire[0].MONTT!), AppColors.deepLimeGreen),


    ];
    if(list_ChiffreAffaire.length >1){
      piedata.add(ChartData(list_ChiffreAffaire[1].NOM!.trimRight(), double.parse(list_ChiffreAffaire[1].MONTT!),AppColors.pinkShade3 ));


    }
    if(list_ChiffreAffaire.length >2){
      piedata.add(ChartData(list_ChiffreAffaire[2].NOM!.trimRight(), double.parse(list_ChiffreAffaire[2].MONTT!), AppColors.lightGreenShade1));
    }

    if(list_ChiffreAffaire.length >3){
      piedata.add(ChartData(list_ChiffreAffaire[3].NOM!.trimRight(), double.parse(list_ChiffreAffaire[3].MONTT!), AppColors.pinkShade2));
    }

    if(list_ChiffreAffaire.length >4){
      piedata.add(ChartData(list_ChiffreAffaire[4].NOM!.trimRight(), double.parse(list_ChiffreAffaire[4].MONTT!), AppColors.StatBlue_light1));
    }
    if(list_ChiffreAffaire.length >5){
      piedata.add(ChartData(list_ChiffreAffaire[5].NOM!.trimRight(), double.parse(list_ChiffreAffaire[5].MONTT!), AppColors.StatBlue_light2));
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
    getType_maint();


  }

  @override
  Widget build(BuildContext context) {

    return Container(

        constraints: BoxConstraints(
            minHeight: 100,  maxHeight: 340.h),

        child:  RefreshIndicator(
          onRefresh: getType_maint,
          key: _refresh,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              :list_ChiffreAffaire.length<1 ?Container(): Center(
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
                              DoughnutSeries<ChartData, String>(
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
                                    labelPosition: ChartDataLabelPosition.outside,
                                    useSeriesColor: true,
                                    connectorLineSettings: ConnectorLineSettings(
                                        type: ConnectorType.curve, length: '25%')
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

  List<M_ChiffreAffaire> list_ChiffreAffaire = [] ;

  ///******************************************************************* get type maintenance curatif preventif  ****************************************/

  Future<void> getType_maint() async {
    setState(() {
      loading = true;
    });
    //print(" payeur ${Global.getPayeur_Stat()} DOS ${Global.getDOS()}");
    String myUrl = BaseUrl.CA_MONT_CLI;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

      "payeur":Global.getPayeur_Stat(),
      "date_debut":Global.getdate_debut_Stat(),
      "date_fin":Global.getdate_fin_Stat(),
      "DOS":Global.getDOS(),

    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body) as List<dynamic>;
        list_ChiffreAffaire = data.map((json) => M_ChiffreAffaire.fromJson(json)).toList();

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
