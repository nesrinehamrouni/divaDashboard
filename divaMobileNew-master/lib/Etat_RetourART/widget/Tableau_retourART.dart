
import 'dart:convert';
import 'dart:io';

import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Api.dart';
import '../../Models/M_RetourART.dart';
import '../../My_globals.dart';
import '../../Utils.dart';
import '../Detail_table.dart';





class Table_RetourART extends StatefulWidget {

  String date_debut;
  String date_fin;



  Table_RetourART({Key? key,  required this.date_debut,required this.date_fin})
      : super(key: key);


  @override
  State<Table_RetourART> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Table_RetourART> {
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRetourART();
    // searchOR();

  }

  List<M_RetourART> Retour_list = [] ;

  ///******************************************************************* get etat de retour****************************************/

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
          "date_fin":widget.date_fin,
          "DOS":Global.getDOS()

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body) as List<dynamic>;
        Retour_list = data.map((json) => M_RetourART.fromJson(json)).toList();


        setState(() {
          loading = false;

        });
      }
    });
  }


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

                    onRefresh: getRetourART,
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
                          showCheckboxColumn: false,
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
                                'Article',
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



                          ],
                          rows: Retour_list.map((ligne) =>
                              DataRow(

                                onSelectChanged: (bool? selected) {

                                  if (selected!) {
                                    Detail_tableRetourART.showDialog(context,ligne.REF,ligne.DES,widget.date_debut,widget.date_fin);
                                  }
                                },
                                cells: <DataCell>[


                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 2,
                                      child: Text(ligne.REF,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),


                                  DataCell(Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10) * 4,

                                    child: Center(
                                      child: Text(ligne.DES,
                                          style: TextStyle(fontSize: 12.sp)),
                                    ),
                                    //onPressed: () {launch('tel:${chauf.PortableC}');},

                                  )

                                  ),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.QTE,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),



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
