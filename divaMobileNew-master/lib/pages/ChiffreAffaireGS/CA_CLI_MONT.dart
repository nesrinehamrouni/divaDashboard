
import '../../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colorApp.dart';
import '../Filter_Stat/filterCA.dart';
import 'widget/Tableau_CA.dart';
import 'widget/dunatChart_CLI_MONT.dart';



class CA_CLI_MONT extends StatefulWidget {
  @override
  CA_list createState() => CA_list();
}

class CA_list extends State<CA_CLI_MONT>with AutomaticKeepAliveClientMixin<CA_CLI_MONT> {
  static const String _title = " Chiffre d'affaire grande surface";

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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;









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
                "Totale chiffre d'affaire net par client",
                style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Colors.black54),),
              SizedBox(height: 10,),
              dunatChart_CLI_MONT(),
            ],
          ) ),
          _buildStatCard( Table_CA() ),






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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Filter_CA()), (route) => false);


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


