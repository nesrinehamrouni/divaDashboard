import 'dart:convert';
import 'dart:io';
import '../../constants.dart';
import '../../pages/Filter_Stat/Filter_Stock.dart';
import '../../pages/Stock/table_stock.dart';
import '../../pages/Stock/Barchar_Stock_Rot_Label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../Api.dart';
import '../../My_globals.dart';
import '../../Utils.dart';
import '../../colorApp.dart';





class Stock_stat extends StatefulWidget {

  String RefART;

  Stock_stat({Key? key, required this.RefART }): super(key:key);

  @override
  Stock_list createState() => Stock_list();
}

class Stock_list extends State<Stock_stat>with AutomaticKeepAliveClientMixin<Stock_stat> {
  static const String _title = " Etat Stock par Reférence";

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
    gettotal();


  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
late int total ;



  Future gettotal() async {
    var baseUrl = BaseUrl.get_total;

    http.Response response = await http.get(Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        total = int.parse(jsonData[0]['total'].toString());
        print("Totaleee:: : ${total}");
      });
    }
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
              // Text(
              //   "stock",
              //   style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Colors.black54),),
              SizedBox(height: 10,),
              Container(constraints: BoxConstraints(
                  minHeight: 200, minWidth: double.infinity, maxHeight: 280.h),
                  child: Barchar_Stock_Rot_Label(REF:widget.RefART)),
            ],
          ) ),
          _buildStatCard( Table_Stock( REF:widget.RefART ) ),






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
            decoration: const BoxDecoration(
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
                      builder: (context) => Filter_Stock()));

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
        ),
        floatingActionButton:Row(
          children: [

            Global.NB_stock != 0  ? Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  child: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                  onPressed: (){
                    setState(() {
                      Global.NB_stock = (Global.NB_stock-10);
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Stock_stat(RefART:widget.RefART)));
                  }
              ),
            )
                : Container(height: 10,),
            Spacer(),
            FloatingActionButton(
            onPressed: () {
              setState(() {
               Global.NB_stock = (Global.NB_stock+10);
              });

              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Stock_stat(RefART: widget.RefART,)));
    },
    backgroundColor: kPrimaryColor,
    child: const Icon(Icons.arrow_forward_ios,color: Colors.white,),


    ),

          ],
        ),
    );
  }

  Container _buildStatCard(Widget widget) {
    return Container(

      margin: const EdgeInsets.all(8.0),
      //padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow:  const [
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


