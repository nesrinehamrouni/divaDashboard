import 'dart:convert';
import 'dart:io';
import '../../Models/M_FA_nonPay%C3%A9_CLI.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Api.dart';
import '../../../My_globals.dart';
import '../../../Utils.dart';





class Table_FA_nonPayer extends StatefulWidget {
  String? CLI;
  String? REP;
  String? ETB;
  String date_debut;
  String date_fin;



  Table_FA_nonPayer({Key? key,  this.CLI,this.REP,this.ETB,required this.date_debut,required this.date_fin})
      : super(key: key);


  @override
  State<Table_FA_nonPayer> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Table_FA_nonPayer> {
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFA();
    // searchOR();

  }

  List<M_FA> FA_list = [] ;

  ///******************************************************************* get mission ****************************************/

  Future<void> getFA() async {
    setState(() {
      loading = true;
    });

    String myUrl = widget.REP !="" ?BaseUrl.getdetailFA_REP:BaseUrl.getFA_nonPaye_CLI;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "ETB":widget.ETB,
          "client":widget.CLI,
          "representant":widget.REP,
          "date_debut":widget.date_debut,
          "date_fin":widget.date_fin,
          "DOS":Global.getDOS()

    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body) as List<dynamic>;
        FA_list = data.map((json) => M_FA.fromJson(json)).toList();


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

                    onRefresh: getFA,
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
                                'Date',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'N°facture',
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
                                'Payé',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Reste',
                                style: TextStyle(fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),







                          ],
                          rows: FA_list.map((ligne) =>
                              DataRow(
                                cells: <DataCell>[


                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.FADT,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),


                                  DataCell(Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10) * 2.4,

                                    child: Center(
                                      child: Text(ligne.NUM_FC,
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
                                      child: Text(ligne.MT,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.PAYE,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.RESTE,
                                          style: TextStyle(
                                              fontSize: 12.sp)))),


                                  // DataCell(Container(
                                  //     width: (MediaQuery
                                  //         .of(context)
                                  //         .size
                                  //         .width / 10) * 1.3,
                                  //     child: TextButton(
                                  //       onPressed: (){Detail_tableCA.showDialog(context,ligne);},
                                  //         child:Text("Plus détail",
                                  //         style: TextStyle(
                                  //             fontSize: 13.sp,color: Colors.blue))))),


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
