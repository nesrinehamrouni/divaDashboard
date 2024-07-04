import '../Etat_RetourART/widget/Barchar_RetourREP_Rot_Label.dart';
import '../Etat_RetourART/widget/Tableau_retourART.dart';
import '../Etat_RetourART/widget/Tableau_retourREP.dart';
import '../Etat_RetourART/widget/dunatChart_RetourART.dart';
import '../constants.dart';
import '../pages/Filter_Stat/Filter_RetourART.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colorApp.dart';
import '../My_globals.dart';



class RetourART extends StatefulWidget {

  String date_debut;
  String date_fin;



  RetourART({Key? key,  required this.date_debut,required this.date_fin})
      : super(key: key);

  @override
  RetourART_list createState() => RetourART_list();
}

class RetourART_list extends State<RetourART> {
  static const String _title = " Etat retour article";

  Widget WidgetTitle = Text(
    _title,
    style: TextStyle(fontSize: 17.sp,color: Colors.white),
  );





  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();


  var loading = false;






  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }

  /******************************************************** build stat *****************************************/
  Widget _buildStatistique(){

    return Container(
      height: MediaQuery.of(context).size.height *1.9,
      child: Column(
        children: <Widget>[
          _buildStatCard(Column(
            children: [
              SizedBox(height: 10,),
            Text(
              Global.getisRetourRep() == "Représentant" ?"Top 10 retour par représentant " : "Top 10 retour par article " ,
                style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Colors.black54),),
              SizedBox(height: 10,),
              Global.getisRetourRep() == "Représentant" ?  Barchar_RetourREP(date_debut: widget.date_debut, date_fin: widget.date_fin)
              : dunatChart_RetourART(date_debut: widget.date_debut, date_fin: widget.date_fin),
            ],
          ) ),
          _buildStatCard( Global.getisRetourRep() == "Représentant"? Table_RetourREP(date_debut: widget.date_debut, date_fin: widget.date_fin):
          Table_RetourART(date_debut: widget.date_debut, date_fin: widget.date_fin) ),






        ],
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
                      builder: (context) => Filter_Retour()));


            },
          ),

          title:WidgetTitle,


        ),

        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildStatistique(),
                const SizedBox(
                  height: 20,
                ),

              ]),
        )
    );
  }

  Container _buildStatCard(Widget widget) {
    return Container(

      margin: const EdgeInsets.all(8.0),
      //padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow:  [
          BoxShadow(
            color: AppColors.lightBlueShade2,
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 2.0, //extend the shadow


            offset: Offset(
              5.0, // Move to right 5  horizontally
              5.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: widget,
    );


  }




}


