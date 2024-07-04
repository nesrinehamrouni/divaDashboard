
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../Menu/Menu.dart';
import 'Filter_Stock.dart';
import 'filterCA.dart';



class Filter_Stat extends StatefulWidget {

  const Filter_Stat({Key? key,}) : super(key: key);

  // Declare a field that holds the Todo.
  //final int todo;

  @override
  FilterStat_State createState() => FilterStat_State();
}

class FilterStat_State extends State<Filter_Stat> {


  Icon cusicon = Icon(Icons.search);
  Widget cusSearchbar = Text("Filter");

  @override
  Widget build(BuildContext context) => DefaultTabController(
   // initialIndex:widget.todo,
    length: 2,
    child: Scaffold(

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
                      builder: (context) => Menu()));

            },
          ),

          title:Text( " Filtre",style: TextStyle(fontSize: 19.sp,color: Colors.white,fontWeight: FontWeight.bold),),



          //backgroundColor: Colors.purple,

          bottom: TabBar(
            onTap: (int index) {
              //  print('Tab $index is tapped');
             // ajouter_qui=index.toString();
            },
            //isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14.5,fontWeight: FontWeight.bold),
            indicatorWeight: 5,
            tabs: const [
              Tab(icon:Icon(Icons.store,size: 40,color: Colors.white), text: 'Stock'),
              Tab(icon: Icon(Icons.data_exploration_sharp,size: 40,color: Colors.white), text: "Chiffre d'affaire"),

            ],
          ),
          elevation: 20,

          iconTheme: IconThemeData(color: Colors.white),
        ),

        body: TabBarView(


          children: [
            buildPage('Stock'),
            buildPage("Chiffre d'affaire"),

          ],

        ),

    ),
  );

  Widget buildPage(String text) {

    final List<int> id = [10,20,30,40,50,60,70];

    if(text == 'Stock')
      return Container(
        padding: EdgeInsets.only(top: 30),
         child: Filter_Stock(),
      );
    else
      return Container(
        padding: EdgeInsets.only(top: 30),
        child: Filter_CA(),
      );
  }








}