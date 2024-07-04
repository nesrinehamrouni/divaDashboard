import 'dart:convert';
import 'dart:io';
import '../../../Models/M_ChiffreAffaire.dart';
import '../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Api.dart';
import '../../../My_globals.dart';
import '../../../Utils.dart';
import 'détail_table.dart';




class Table_CA extends StatefulWidget {
  const Table_CA({super.key}) ;


  @override
  State<Table_CA> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Table_CA> {
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmission();
    // searchOR();

  }

  List<M_ChiffreAffaire> CA_list = [] ;

  ///******************************************************************* get mission ****************************************/

  Future<void> getmission() async {
    setState(() {
      loading = true;
    });
print(" payeur ${Global.getPayeur_Stat()}");
    String myUrl = BaseUrl.CA_listDetail;
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
        final data = jsonDecode(response.body);
        data.forEach((api) {


          final ab =  M_ChiffreAffaire.Detail(

            api['TIERS'].toString() ,
            api['NOM'].toString(),
            api['N_FACT'].toString().replaceAll('  ', '') ,
            api['PIDT'].toString() ,
            double.parse(api['CA_Brut']).toStringAsFixed(3) ,
            double.parse(api['CAB_FOD']).toStringAsFixed(3) ,
            double.parse(api['MT_Rem']).toStringAsFixed(3) ,
            double.parse(api['NET_FOD']).toStringAsFixed(3) ,
            double.parse(api['CA_TTC']).toStringAsFixed(3) ,
            double.parse(api['SREM_0001']).toStringAsFixed(3) ,
            api['TVAART'].toString() ,
            api['SFAQTE'].toString() ,
            double.parse(api['TTC_SUM']).toStringAsFixed(3) ,
           " ${
              (double.parse(api['MT_Rem']) / double.parse(api['CAB_FOD']))
                  .toStringAsFixed(0)
                  .toString()
            } %",
          );
          CA_list.add(ab);


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

        // borderRadius: const BorderRadius.all(
        //     Radius.circular(10.0)),
        // border: Border.all(
        //     color: Colors.blue.shade800, // Set border color
        //     width: 2.0),
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

                    onRefresh: getmission,
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
                              .width / 10) * 0.2,
                          dataRowHeight: 50,
                          headingRowHeight: 35,
                          //border: TableBorder(borderRadius: BorderRadius.circular(20)),

                          headingRowColor: WidgetStateColor.resolveWith((
                              states) => primaryColor),
                          columns: <DataColumn>[

                            DataColumn(
                              label: Text(
                                'N°Client',
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
                                'N°FACT',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                ' ',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),

                            // DataColumn(
                            //   label: Text(
                            //     '',
                            //     style: TextStyle(fontSize: 16.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white),
                            //   ),
                            // ),



                          ],
                          rows: CA_list.map((ligne) =>
                              DataRow(
                                cells: <DataCell>[


                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.7,
                                      child: Text(ligne.TIERS!,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),


                                  DataCell(Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10) * 2.8,

                                    child: Center(
                                      child: Text(ligne.NOM!,
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
                                      child: Text(ligne.N_FACT!,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.3,
                                      child: TextButton(
                                        onPressed: (){Detail_tableCA.showDialog(context,ligne);},
                                          child:Text("Plus détail",
                                          style: TextStyle(
                                              fontSize: 13.sp,color: Colors.blue))))),


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
