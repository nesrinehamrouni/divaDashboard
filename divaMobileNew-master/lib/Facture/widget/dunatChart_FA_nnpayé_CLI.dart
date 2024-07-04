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


class dunatChart_FA_NonPaye_CLI extends StatefulWidget {
  String? CLI;
  String? REP;
  String? ETB;
  String date_debut;
  String date_fin;



  dunatChart_FA_NonPaye_CLI({Key? key,  this.CLI,this.REP,this.ETB,required this.date_debut,required this.date_fin})
      : super(key: key);

  _HomePageS createState() => _HomePageS();
}

class _HomePageS extends State<dunatChart_FA_NonPaye_CLI> {


  late List<ChartData> chartData;



  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();
  var loading = false;


  Future _generateData() async {


    var piedata = [

      ChartData( "Payée", double.parse(list_FA_CLI_TT[0].PAYET), AppColors.deepLimeGreen),
      ChartData("Reste", double.parse(list_FA_CLI_TT[0].RESTET),AppColors.pinkShade3 )

    ];
    // if(list_FA_CLI_TT.length == 1){
    //   piedata.add(ChartData("Reste", double.parse(list_FA_CLI_TT[0].RESTET!),AppColors.pinkShade3 ));
    //
    //
    // }

    // if(list_ChiffreAffaire.length >2){
    //   piedata.add(ChartData(list_ChiffreAffaire[2].NOM!.trimRight(), double.parse(list_ChiffreAffaire[2].MONTT!), AppColors.lightGreenShade1));
    // }




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
    getTotal();


  }

  @override
  Widget build(BuildContext context) {

    return Container(

        constraints: BoxConstraints(
            minHeight: 100,  maxHeight: 340.h),

        child:  RefreshIndicator(
          onRefresh: getTotal,
          key: _refresh,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              :list_FA_CLI_TT.length<1 ?Container(): Center(
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

  List<FA_TotalNonPaye> list_FA_CLI_TT = []  ;

  ///******************************************************************* get type maintenance curatif preventif  ****************************************/

  Future<void> getTotal() async {
    setState(() {
      loading = true;
    });

    String myUrl =  widget.REP !="" ?BaseUrl.getTotalFA_nonPaye_Rep:BaseUrl.getTotalFA_nonPaye_CLI;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "ETB":widget.ETB,
          "client":widget.CLI,
          "representant":widget.REP,
          "date_debut":widget.date_debut,
          "date_fin":  widget.date_fin,
          "DOS":Global.getDOS()

    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);

        data.forEach((api) {


          final ab =  FA_TotalNonPaye(
            api['MTT'].toString(),
            api['PAYET'].toString(),
            api['RESTET'].toString(),

          );
          list_FA_CLI_TT.add(ab);


        });
        setState(() {
          loading = false;
          _generateData();
        });

      }
    });
  }


}
class ChartData {
  ChartData(this.x, this.y,this.color );
  final String x;
  final Color color;
  final double y;

}

class FA_TotalNonPaye {

  FA_TotalNonPaye(this.MTT, this.PAYET,this.RESTET );
  String MTT;
  String PAYET;
  String RESTET;




}
