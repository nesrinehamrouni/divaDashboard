import 'dart:convert';
import 'dart:io';
import '../constants.dart';
import '../pieceCLI/d%C3%A9tail_tableP.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:side_sheet/side_sheet.dart';
import '../../../Api.dart';
import '../../../Utils.dart';
import '../Models/M_PieceCLI.dart';
import '../My_globals.dart';
import '../pages/Filter_Stat/Filter_TextFeild.dart';
import '../pages/Menu/Menu.dart';
import '../responsive.dart';
import '../widget/dropDownTIERS.dart';
import 'InputDate.dart';
import 'dropdown_Etat.dart';
import 'dropdown_PICOD.dart';




class PieceCLI extends StatefulWidget {
  const PieceCLI({super.key}) ;


  @override
  State<PieceCLI> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<PieceCLI> {


  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  var loading = false;

  static const String _title = " Consultation Pièces client";

  Widget WidgetTitle = Text(
    _title,
    style: TextStyle(fontSize: 17.sp,color: Colors.white),
  );

  TextEditingController _ETBController = TextEditingController();
  TextEditingController _PICODController = TextEditingController();
  TextEditingController _EtatController = TextEditingController();
  TextEditingController _TiersController = TextEditingController();
  TextEditingController _DateFromController = TextEditingController();
  TextEditingController _DateToController = TextEditingController();
  TextEditingController _PINODuController = TextEditingController();
  TextEditingController _PINOToController = TextEditingController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPieceCLI();
    // searchOR();

  }

  List<M_PieceCLI> PieceCLI_list = [] ;

  ///******************************************************************* get Piece ****************************************/

  Future<void> getPieceCLI() async {
    setState(() {
      loading = true;
    });

    String myUrl = BaseUrl.get_PieceCLI;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
        },
        body: {

          "ETB":         Global.getETB() ,
          "DOS":          Global.getDOS(),
          "CE4":         _EtatController.text ,
          "Tiers":       _TiersController.text,
          "PICOD":       _PICODController.text,
          "date_debut":  _DateFromController.text,
          "date_fin":    _DateToController.text,
          "PINO1":       _PINODuController.text,
          "PINO2":       _PINOToController.text,

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      print('Request : ETB:${_ETBController.text } etat:${_EtatController.text } Tiers:${_TiersController.text } '
          'PICOD:${_PICODController.text } date:${_DateFromController.text } ${_DateToController.text } pino:${_PINODuController.text }');

      if (response.statusCode == 200) {


        final data = jsonDecode(response.body) as List<dynamic>;
        PieceCLI_list = data.map((json) => M_PieceCLI.fromJson(json)).toList();


        setState(() {
          loading = false;

        });
      }
    });
  }
  // TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar:  AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: <Color>[accentColor, primaryColor]),
          ),
        ),
        titleSpacing: 20.0,
        leading:  IconButton(
          icon:  Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Menu()), (route) => false);


          },
        ),

        title:WidgetTitle,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(
              //margin: EdgeInsets.all(10),
              //padding: EdgeInsets.all(5),

              constraints: BoxConstraints(
                   minWidth: double.infinity),
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

                            onRefresh: getPieceCLI,
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
                                        'Date',
                                        style: TextStyle(fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Préfixe',
                                        style: TextStyle(fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'N°Piece',
                                        style: TextStyle(fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        'Tièrs',
                                        style: TextStyle(fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Montant HT',
                                        style: TextStyle(fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),

                                    if (!ResponsiveWidget.isSmallScreen(context)) DataColumn(
                                      label: Text(
                                        'Etat',
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



                                  ],
                                  rows: PieceCLI_list.map((ligne) =>
                                      DataRow(

                                        onSelectChanged: (bool? selected) {

                                          if (selected!) {
                                            Detail_tablePCLI.showDialog(context,ligne);
                                          }
                                        },
                                        cells: <DataCell>[


                                          DataCell(Container(
                                              width: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 10) * 2,
                                              child: Text(ligne.PIDT,
                                                  style: TextStyle(
                                                      fontSize: 13.sp)))),


                                          DataCell(Container(
                                            width: (MediaQuery
                                                .of(context)
                                                .size
                                                .width / 10) * 1.8,

                                            child: Center(
                                              child: Text(ligne.PREFPINO,
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
                                              child: Text(ligne.PINO,
                                                  style: TextStyle(
                                                      fontSize: 13.sp)))),

                                          DataCell(Container(
                                              width: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 10) * 1.8,
                                              child: Text(ligne.TIERS,
                                                  style: TextStyle(
                                                      fontSize: 13.sp)))),

                                          DataCell(Container(
                                              width: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 10) * 1.8,
                                              child: Text(ligne.HTMT,
                                                  style: TextStyle(
                                                      fontSize: 13.sp)))),

                                          if (!ResponsiveWidget.isSmallScreen(context)) DataCell(Container(
                                              width: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 10) * 1.8,
                                              child: Text(ligne.CE4,
                                                  style: TextStyle(
                                                      fontSize: 13.sp)))),

                                          DataCell(Container(
                                              width: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 10) * 1.3,
                                              child: TextButton(
                                                  onPressed: (){
                                                    Detail_tablePCLI.showDialog(context,ligne);
                                                    },
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
                              )
                            ),
                          ),
                        ),
                      )

                    ]),
              ),

            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.filter_alt_outlined,color: Colors.white,),
          onPressed: (){
            SideSheet.right(
                width: MediaQuery.of(context).size.width * 0.8,
                body:_FilterWidget(),

                context: context);

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Stock_stat()));
          }
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildText(String txt){

    return Container(
     // margin: EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          txt,
          style:  TextStyle(
              color: primaryColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

  }

  Widget _FilterWidget(){

    return Scaffold(
     // resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
              //   _buildText("Etablissement"),
              //   SizedBox(height: 5.h,),
              //
              //   Container(height:45,
              // child: Row(
              //   children: [
              //     Expanded(flex:4,child: FilterTextField(label: 'Etablissement',controller: _ETBController,)),
              //     Expanded(flex:1,child: SizedBox(width: 1,)),
              //   ],
              // )) ,
                SizedBox(height: 20.h,),

                _buildText("Tiers"),
                SizedBox(height: 5.h,),
                dropdown_TIERS( TIERSController: _TiersController,) ,
                SizedBox(height: 15.h,),
                _buildText("Etat"),
                SizedBox(height: 5.h,),

                dropdown_Etat(EtatController: _EtatController),
                SizedBox(height: 15.h,),
                _buildText("Type Pièce"),
                SizedBox(height: 5.h,),
                dropdown_PICOD(PICODController: _PICODController),
                SizedBox(height: 15.h,),
                _buildText("date"),
                SizedBox(height: 5.h,),
                Row(
                  children: [
                    Expanded(flex:1,child: Text("du",style: TextStyle(color: Colors.blueGrey),)),
                    Expanded(flex:6,child: InputDate(DateController: _DateFromController,text: "date du",)),
                    Expanded(flex:1,child: Text("au",style: TextStyle(color: Colors.blueGrey),)),
                    Expanded(flex:6,child: InputDate(DateController: _DateToController,text: "jusqu'à")),
                  ],
                ),



                SizedBox(height: 15.h,),
                _buildText("Numéro pièce"),
                SizedBox(height: 5.h,),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Expanded(flex:4,child: FilterTextField(label: "du",controller:_PINODuController ,)),
                    const Expanded(flex:1,child: SizedBox(width: 10,)),
                    Expanded(flex:4,child: FilterTextField(label: "au",controller:_PINOToController ,))

                  ],),
                ),
                SizedBox(height: 25.h,),
                buildElevatedButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildElevatedButton() {
    return Container(
      width: 150.w,
      height: 40.r,
      margin: EdgeInsets.only(right: 50),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],

        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(


        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),

        child: Text('Rechercher', style: TextStyle(fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600),),

        onPressed: () async {

          getPieceCLI();
          Navigator.pop(
              context, 'Data returns from right side sheet');

        },
      ),
    );

  }


  // ///******************************************************************* search Piece ****************************************/
  //
  // Future<void> searchCLI() async {
  //   setState(() {
  //     loading = true;
  //   });
  //
  //   String myUrl = BaseUrl.get_PieceCLI;
  //   http.post(Uri.parse(myUrl),
  //       headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
  //       },
  //       body: {
  //
  //          "ETB":         _ETBController.text  ,
  //          "CE4":         _EtatController.text ,
  //          "Tiers":       _TiersController.text,
  //          "PICOD":       _PICODController.text,
  //          "date_debut":  _DateFromController.text,
  //          "date_fin":    _DateToController.text,
  //          "PINO1":       _PINODuController.text,
  //          "PINO2":       _PINOToController.text,
  //
  //
  //       }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //
  //
  //       final data = jsonDecode(response.body) as List<dynamic>;
  //       PieceCLI_list = data.map((json) => M_PieceCLI.fromJson(json)).toList();
  //
  //
  //       setState(() {
  //         loading = false;
  //
  //       });
  //     }
  //   });
  // }

}
