import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../Menu/Menu.dart';
import 'Filter.dart';
import 'Filter_Stock.dart';
import 'filterCA.dart';


class Filter_Responsive extends StatefulWidget {
  const Filter_Responsive({Key? key}) : super(key: key);

  @override
  State<Filter_Responsive> createState() => _Filter_ResponsiveState();
}

class _Filter_ResponsiveState extends State<Filter_Responsive> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: ResponsiveWidget.isSmallScreen(context) ? Filter_Stat() :
        Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: <Color>[accentColor, primaryColor]),
              ),
              child: Row(children: [
                SizedBox(width: 20.w,),
                Text("Stock",style: TextStyle(color: Colors.white,fontSize: 19.sp),),
                Spacer(),
                Text("Chiffre d'affaire",style: TextStyle(color: Colors.white,fontSize: 19.sp),),
                SizedBox(width: 20.w,),
              ],),
            ),
            titleSpacing: 20.0,
            leading:  IconButton(
              icon:  Icon(Icons.arrow_back,color: primaryColor,),
              onPressed: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Menu()));

              },
            ),

          //  title:Text( " Filtre",style: TextStyle(fontSize: 19.sp,color: Colors.white,fontWeight: FontWeight.bold),),



            //backgroundColor: Colors.purple,


            elevation: 20,

            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                  child:Filter_Stock()
              ),
              Expanded(
                  child:Filter_CA()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
