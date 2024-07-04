import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../Utils.dart';



class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MyHomePage();

  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [];

  bool loading = false;
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();
  //   _SalesData('Jan', 35),
  //   _SalesData('Feb', 28),
  //   _SalesData('Mar', 34),
  //   _SalesData('Apr', 32),
  //   _SalesData('May', 40),
  //   _SalesData('2', 50),
  //   _SalesData('4', 100),
  //   _SalesData('7', 10),
  //   _SalesData('8', 40),
  //   _SalesData('6', 60),
  //   _SalesData('3', 200),
  //   _SalesData('9', 5),
  //   _SalesData('10', 0),
  //   _SalesData('11', 250),
  // ];


  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from the API when the widget initializes
  }

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
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        var jsonData = jsonDecode(response.body);
       // var apiData = jsonData[jsonData];
        // Map the API data to _SalesData objects
        List<_SalesData> fetchedData = jsonData.map<_SalesData>((item) => _SalesData((item['REF']).toString(), double.parse((item['QTE']).toString()))).toList();



        setState(() {
          loading = false;
        });

        setState(() {
          data = fetchedData; // Update the 'data' list with the fetched data
        });

    }
  });
        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: RefreshIndicator(

            onRefresh: fetchData,
            key: _refresh,
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Column(children: [
            //Initialize the chart widget
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'quantité par Article'),
                // Enable legend
                //legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'QTE',

                      // Enable data label
                      //dataLabelSettings: DataLabelSettings(isVisible: true)
                  )
                ]),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     //Initialize the spark charts widget
            //     child: SfSparkLineChart.custom(
            //       //Enable the trackball
            //       trackball: SparkChartTrackball(
            //           activationMode: SparkChartActivationMode.tap),
            //       //Enable marker
            //       marker: SparkChartMarker(
            //           displayMode: SparkChartMarkerDisplayMode.all),
            //       //Enable data label
            //       labelDisplayMode: SparkChartLabelDisplayMode.all,
            //       xValueMapper: (int index) => data[index].year,
            //       yValueMapper: (int index) => data[index].sales,
            //       dataCount: 5,
            //     ),
            //   ),
            // )
          ]),
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}