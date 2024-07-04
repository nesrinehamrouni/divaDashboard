import 'dart:convert';
import 'dart:io';
import 'package:divamobile/pages/ChiffreAffaireGS/widget/detail_table_CA_SH.dart';

import '../../../Models/M_ChiffreAffaire.dart';
import '../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Api.dart';
import '../../../My_globals.dart';
import '../../../Utils.dart';




class Table_CA_SH extends StatefulWidget {
  String date_debut;
  String date_fin;



  Table_CA_SH({Key? key,  required this.date_debut,required this.date_fin})
      : super(key: key);


  @override
  State<Table_CA_SH> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Table_CA_SH> {
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCA();
    // searchOR();

  }

  List<M_ChiffreAffaire> CA_list = [] ;

  ///******************************************************************* get mission ****************************************/

  Future<void> getCA() async {
    setState(() {
      loading = true;
    });

    String myUrl = BaseUrl.CA_getCA_ShowRoom;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {


          "date_debut":widget.date_debut,
          "date_fin":widget.date_fin,
          "DOS":Global.getDOS(),

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body of table ca sh : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data.forEach((api) {


          final ab =  M_ChiffreAffaire(

            api['TIERS'].toString() ,
            api['NOM'].toString(),
            double.parse(api['MONT']).toStringAsFixed(3),
            // api['N_FACT'].toString().replaceAll('  ', '') ,
            // api['PIDT'].toString() ,
            // double.parse(api['CA_Brut']).toStringAsFixed(3) ,
            // double.parse(api['CAB_FOD']).toStringAsFixed(3) ,
            // double.parse(api['MT_Rem']).toStringAsFixed(3) ,
            // double.parse(api['NET_FOD']).toStringAsFixed(3) ,
            // double.parse(api['CA_TTC']).toStringAsFixed(3) ,
            // double.parse(api['SREM_0001']).toStringAsFixed(3) ,
            // api['TVAART'].toString() ,
            // api['SFAQTE'].toString() ,
             api['TTC_SUM'].toString(),
            // " ${
            //     (double.parse(api['MT_Rem']) / double.parse(api['CAB_FOD']))
            //         .toStringAsFixed(0)
            //         .toString()
            // } %",
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

                    onRefresh: getCA,
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
                              .width / 10) * 0.15,
                          dataRowHeight: 50,
                          headingRowHeight: 35,
                          //border: TableBorder(borderRadius: BorderRadius.circular(20)),

                          headingRowColor: WidgetStateColor.resolveWith((
                              states) => primaryColor),
                          columns: <DataColumn>[

                            DataColumn(
                              label: Text(
                                'N°SR',
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
                                'Montant',
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
                                          .width / 10) * 2,
                                      child: Text(ligne.MONTT!,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.3,
                                      child: TextButton(
                                          onPressed: (){
                                            _showdetail(ligne.TIERS!);
                                            },
                                          child:Text("Plus détail",
                                              style: TextStyle(
                                                  fontSize: 12.sp,color: Colors.blue[600]))))),


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

  Future<void> _showdetail(String TIERS) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: Container(
            height: 400.h,
            width: 420.w,

            child: Detail_Table_CA_SH(date_debut:widget.date_debut,date_fin:widget.date_fin, ShowRoom: TIERS,)
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok',style: TextStyle(color: Colors.blue[600]!),),
              onPressed: () async {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



}

