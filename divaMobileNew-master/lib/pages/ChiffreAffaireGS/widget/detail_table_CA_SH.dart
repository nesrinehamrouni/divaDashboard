
//
// @override
// Widget build(BuildContext context) {
//   return Column(children: [
//     Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchController,
//         decoration: const InputDecoration(
//           hintText: 'Search...',
//           border: OutlineInputBorder(),
//         ),
//         onChanged: _onSearchTextChanged,
//       ),
//     ),
//     SizedBox(
//       width: double.infinity,
//       child: DataTable(
//         columns: const <DataColumn>[
//           DataColumn(
//             label: Text('Name'),
//           ),
//           DataColumn(
//             label: Text('Age'),
//             numeric: true,
//           ),
//           DataColumn(
//             label: Text('Role'),
//           ),
//         ],
//         rows: List.generate(filteredData.length, (index) {
//           final item = filteredData[index];
//           return DataRow(
//             cells: [
//               DataCell(Text(item['Name'])),
//               DataCell(Text(item['Age'].toString())),
//               DataCell(Text(item['Role'])),
//             ],
//           );
//         }),
//       ),
//     ),
//   ]);
// }
// }

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




class Detail_Table_CA_SH extends StatefulWidget {
  String date_debut;
  String date_fin;
  String ShowRoom;



  Detail_Table_CA_SH({Key? key,  required this.date_debut,required this.date_fin,required this.ShowRoom})
      : super(key: key);


  @override
  State<Detail_Table_CA_SH> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Detail_Table_CA_SH> {

  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;

  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
    // searchOR();

  }

   @override
void dispose() {
  searchController.dispose();
  super.dispose();
}

void _onSearchTextChanged(String text) {
  setState(() {
    filteredData = text.isEmpty
        ? CA_list
        : CA_list
        .where((item) =>
    item.NUM_PIECE!.toLowerCase().contains(text.toLowerCase()) )
        .toList();
  });
}

  List<M_ChiffreAffaire> CA_list = [] ;
  List<M_ChiffreAffaire> filteredData = [];
  ///******************************************************************* get mission ****************************************/

  Future<void> getdetail() async {
    setState(() {
      loading = true;
    });
    print(" ShowRoom ${Global.getPayeur_Stat()}");
    String myUrl = BaseUrl.CA_getCA_ShowRoom_detail;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "ShowRoom":widget.ShowRoom,
          "date_debut":widget.date_debut,
          "date_fin":widget.date_fin,
          "DOS":Global.getDOS(),

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data.forEach((api) {


          final ab =  M_ChiffreAffaire.DetailSH(

            api['TIERS'].toString() ,
            api['NOM'].toString(),
            api['NUM_PIECE'].toString().replaceAll('  ', '') ,
            api['FADT'].toString() ,
            api['MONT'].toString() ,

          );
          CA_list.add(ab);


        });

        setState(() {
          loading = false;
          filteredData = CA_list ;

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

        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        child: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search N°Piece',
            border: OutlineInputBorder(),
          ),
          onChanged: _onSearchTextChanged,
        ),
      ),
    ),

              Scrollbar(
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(

                  scrollDirection: Axis.horizontal,
                  child: RefreshIndicator(

                    onRefresh: getdetail,
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
                              .width / 10) * 0.05,
                          dataRowHeight: 50,
                          headingRowHeight: 35,
                          //border: TableBorder(borderRadius: BorderRadius.circular(20)),

                          headingRowColor: WidgetStateColor.resolveWith((
                              states) => primaryColor),
                          columns: <DataColumn>[

                            DataColumn(
                              label: Text(
                                'N°Piece',
                                style: TextStyle(fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Date Fact',
                                style: TextStyle(fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Montant',
                                style: TextStyle(fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),


                          ],
                            rows: List.generate(filteredData.length, (index) {
    final ligne = filteredData[index];
    return
                              DataRow(
                                cells: <DataCell>[


                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.8,
                                      child: Text(ligne.NUM_PIECE!,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),


                                  DataCell(Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10) * 2.2,

                                    child: Center(
                                      child: Text(ligne.FADT!,
                                          style: TextStyle(fontSize: 13.sp)),
                                    ),
                                    //onPressed: () {launch('tel:${chauf.PortableC}');},

                                  )

                                  ),

                                  DataCell(Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 10) * 1.5,
                                      child: Text(ligne.MONT!,
                                          style: TextStyle(
                                              fontSize: 13.sp)))),




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
                              );
                            }

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
