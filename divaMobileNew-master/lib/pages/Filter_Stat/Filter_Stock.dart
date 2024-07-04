
import 'package:divamobile/pages/Filter_Stat/dropdown_REFART.dart';

import '../../pages/Menu/MenuBI.dart';
import '../../pages/Stock/widget/dropdown_familleART.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../My_globals.dart';
import '../../constants.dart';
import '../Stock/Stock_Stat.dart';
import 'dropdown_Depot.dart';




class Filter_Stock extends StatefulWidget {
  //late final ValueChanged<bool> update;
  // Filter_CA({required this.update});

  const Filter_Stock({Key? key, }): super(key:key);
  @override
  State<Filter_Stock> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<Filter_Stock> {


  var submitTextStyle = GoogleFonts.rubik(
      fontSize: 18.sp,
      letterSpacing: 3,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();


  TextEditingController _FamARTController = TextEditingController();
  TextEditingController _DOSController = TextEditingController();
  TextEditingController _DepotController = TextEditingController();
  TextEditingController _RefArtController = TextEditingController();

  var loading = false;
  bool is_selected = false;
  bool is_DosVisible = false;
  bool is_DepotVisible = false;
  bool is_FamArtVisible = false;
  bool is_RefArtVisible = false;

  void Function(String)? changeVisible(String isvisible){
    if(isvisible == "Dos" ){setState(() {
      _DOSController.text !=""?
      is_DosVisible = true:is_DosVisible=false;
    });}
    if(isvisible == "Depot" ){setState(() {
      _DepotController.text !=""?
      is_DepotVisible = true:is_DepotVisible=false;
    });}
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _DepotController.text = Global.getDepot_Stat();
    _DOSController.text = Global.getDOS_Stat();




  }

  Widget _buildText(String txt){

    return Container(
      margin: EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          txt,
          style:  TextStyle(
              color: primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Menu_BI()));

          },
        ),

        title:Text( " Filtre Stock",style: TextStyle(fontSize: 19.sp,color: Colors.white,fontWeight: FontWeight.bold),),


      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 20,),

            Container(
              margin: EdgeInsets.only(left: 10,top: 40),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  _buildText("Famille :"),
                  Container(

                      margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                      child: Row(
                        children: [
                          Expanded(flex:4 ,child: dropdown_FamART(FamARTController: _FamARTController)),
                          Expanded(
                              flex: 1,
                              child: Visibility(child: IconButton(onPressed: (){
                                _FamARTController.clear();
                                Global.set_FamART_Stat("");
                              },
                                icon: const Icon(Icons.delete_outline),),visible: is_FamArtVisible,))
                        ],
                      )),
                  SizedBox(height: 30,),
                  // _buildText("Dossier :"),
                  // Container(
                  //     height: 45.w,
                  //     margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                  //     child: Row(
                  //       children: [
                  //         Expanded(flex:4 ,child: FilterTextField(label:"DOS",controller: _DOSController,onChanged: changeVisible("Dos"))),
                  //         Expanded(
                  //             flex: 1,
                  //             child: Visibility(child: IconButton(onPressed: (){
                  //              setState(() {
                  //                _DOSController.text="1";
                  //                Global.set_DOS_Stat("1");
                  //                is_DosVisible = false ;
                  //                print("is visible $is_DosVisible");
                  //              });
                  //             },
                  //               icon: const Icon(Icons.delete_outline),),visible: is_DosVisible,))
                  //       ],
                  //     )),
                  SizedBox(height: 20,),
                  _buildText("Dépot :"),
                  Container(
height: 45.w,
                      margin:EdgeInsets.only(top: 10,left: 30,right: 20),
                      child: Row(
                        children: [
                          Expanded(flex:4 ,
                              child:  dropdown_Depot(DepotController: _DepotController,),),
                          Expanded(
                              flex: 1,
                              child: Visibility(child: IconButton(onPressed: (){
                                _DepotController.text="1";
                                setState(() {
                                  is_DepotVisible = false ;
                                  Global.set_Depot_Stat("1");
                                });

                              },
                                icon: const Icon(Icons.delete_outline),),visible: is_DepotVisible,))
                        ],
                      )),
                  SizedBox(height: 20,),
                  _buildText("Reference article :"),
                  Container(

                      margin:EdgeInsets.only(top: 10,left: 20,right: 15),


                              child:dropdown_REFART(RefARTController: _RefArtController,),


                      ),


                  SizedBox(height: 40),
                  buildElevatedButton(),
                  SizedBox(height: 10),
                ],
              ),
            ),





          ],
        ),

      ),


    );
  }

  bool isLoading = false ;

  Widget buildElevatedButton(){
    return Container(
      width: 150.w,
      height: 50.r,
      margin: EdgeInsets.only(right: 50),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0 ,1.0],
          colors: [
            kPrimaryColor,
            kPrimaryColor,


          ],
        ),
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child:  ElevatedButton(


        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20) ),
        ),

        child: isLoading ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white,),
            SizedBox(width: 24),
            // Text('loading ...')
          ],
        ):Text('valider',style: TextStyle(fontSize: 18.sp,color: Colors.white,fontWeight: FontWeight.w600),),

        onPressed: () async {
          if(isLoading)return;
          setState(() {
            isLoading = true ;
            Global.set_FamART_Stat(_FamARTController.text)  ;
            Global.set_DOS_Stat(_DOSController.text)  ;
            Global.set_Depot_Stat(_DepotController.text) ;

          });
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            //widget.update(true);
            isLoading = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Stock_stat(RefART: _RefArtController.text,)));

          });

        },
      ),
    );
  }









  }




