import 'dart:convert';
import 'dart:io';
import 'package:divamobile/Api.dart';

import '../../Models/M_Stock.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../My_globals.dart';
import '../../Utils.dart';





class Table_Stock extends StatefulWidget {

  String REF;
   Table_Stock({Key? key, required this.REF}): super(key:key);


  @override
  State<Table_Stock> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Table_Stock> {
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStock();
    // searchOR();

  }

  List<M_Stock> Stock_list = [] ;

  ///******************************************************************* get Stock ****************************************/

  Future<void> getStock() async {
    setState(() {
      loading = true;
    });

    String myUrl = BaseUrl.get_Stock;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "Depot":Global.getDepot_Stat(),
          "DOS":Global.getDOS(),
          "REFART":widget.REF,
          "NB":Global.NB_stock.toString(),
          "USIM_TYPFAM":Global.getFamART_Stat().toString(),

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
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
  // TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Container(
      //margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(5),

      constraints: BoxConstraints(
          minHeight: 100, minWidth: double.infinity, maxHeight: 300.h),
      decoration: BoxDecoration(

      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Scrollbar(
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(

                  scrollDirection: Axis.horizontal,
                  child: RefreshIndicator(

                    onRefresh: getStock,
                    key: _refresh,
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
//padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)),
                        border: Border.all(
                            color: primaryColor, // Set border color
                            width: 2.0),
                      ),

                      child: DataTable(

                          columnSpacing: (MediaQuery
                              .of(context)
                              .size
                              .width / 10) * 0.3,
                          dataRowHeight: 50,
                          headingRowHeight: 35,
                          //border: TableBorder(borderRadius: BorderRadius.circular(20)),

                          headingRowColor: WidgetStateColor.resolveWith((
                              states) => primaryColor),
                          columns: <DataColumn>[

                            DataColumn(
                              label: Text(
                                'REF',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nom',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Quantité',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),

                            // DataColumn(
                            //   label: Text(
                            //     ' ',
                            //     style: TextStyle(fontSize: 16.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white),
                            //   ),
                            // ),

                            // DataColumn(
                            //   label: Text(
                            //     '',
                            //     style: TextStyle(fontSize: 16.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white),
                            //   ),
                            // ),



                          ],
                          rows: Stock_list.map((ligne) =>
                              DataRow(
                                cells: <DataCell>[


                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.7,
                                      child: Text(ligne.REF,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),


                                  DataCell(Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10) * 4.2,

                                    child: Center(
                                      child: Text(ligne.DES,
                                          style: TextStyle(fontSize: 13.sp)),
                                    ),
                                    //onPressed: () {launch('tel:${chauf.PortableC}');},

                                  )

                                  ),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.QTE.toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: 13.sp)))),

                                  // DataCell(Container(
                                  //     width: (MediaQuery
                                  //         .of(context)
                                  //         .size
                                  //         .width / 10) * 1.3,
                                  //     child: TextButton(
                                  //         onPressed: (){//Detail_tableCA.showDialog(context,ligne);
                                  //           },
                                  //         child:Text("Plus détail",
                                  //             style: TextStyle(
                                  //                 fontSize: 13.sp,color: Colors.blue))))),


                                  // DataCell(Container(
                                  //     width: (MediaQuery
                                  //         .of(context)
                                  //         .size
                                  //         .width / 10) * 2,
                                  //     child: TextButton(
                                  //         onPressed: (){},
                                  //         child:Text("voir Facture",
                                  //             style: TextStyle(
                                  //                 fontSize: 13.sp,color: Colors.orange))))),




                                ],
                              ),

                          ).toList()
                      ),
                    ),
                  ),
                ),
              )

            ]),
      ),

    );
  }

}
