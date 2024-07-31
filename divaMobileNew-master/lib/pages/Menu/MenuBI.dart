
import 'dart:io';

import 'package:divamobile/pages/Filter_Stat/Filter_CA_ShowRoom.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../constants.dart';
import '../../pages/Filter_Stat/Filter_Stock.dart';
import '../../pages/Filter_Stat/filterCA.dart';
import '../Filter_Stat/Filter_FA.dart';
import '../Filter_Stat/Filter_RetourART.dart';
import '../Login/firstScreen.dart';
import 'Menu.dart';




class Menu_BI extends StatefulWidget {
  @override
  State<Menu_BI> createState() => _MenuState();
}

class _MenuState extends State<Menu_BI> {
  final controller = DragSelectGridViewController();
  var taille ;

  @override
  initState()  {

    super.initState();
    controller.addListener(scheduleRebuild);

  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }



  List<String> events = [

    "Chiffre d'affaire par payeur",
    "Chiffre d'affaire ShowRoom",
    "Etat de retour",
    "Facture Non Payée",
    "Stock",




  ];


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home:  Scaffold(
        backgroundColor: Colors.blueGrey[50],
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

          title:Text("Tableau de bord", style: TextStyle(color: Colors.white,)),
          leading:  IconButton(
            icon:  Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Menu()));

            },
          ),

        ),
        body: ListView(
          children: <Widget>[


            // Container(
            //   height: 28.h,
            //   child:  Align(alignment:Alignment.centerRight,
            //       child: IconButton(onPressed: (){
            //
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (context) => FirstScreen()), (route) => false);
            //       }, icon: Icon(Icons.logout,color: Colors.white,))),
            // ),



            Container(
              color: Colors.blueGrey[50],
              height: MediaQuery. of(context). size. height * 1.1,
              padding: EdgeInsets.only(left: 8, right: 8),
              child: ListView(

                physics: BouncingScrollPhysics(),

                children: events.map((title) {
                  //loop all item in events list
                  return GestureDetector(
                    child: Card(
                      elevation:5,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      //  color: Colors.blue[800],
                      margin:  EdgeInsets.all(5.r),
                      child: Container(
                        //height: 50.h,
                        // width: 150.w,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: getCardByTitle(title)//declare your widget here
                      ),
                    ),
                    onTap: () {


                      if (title == "Stock") {
                        setState(() {
                          Global.NB_stock =0;
                          Global.set_FamART_Stat("");
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter_Stock()));
                      }

                      if (title == "Facture Non Payée") {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter_FA()));
                      }
                      if (title == "Chiffre d'affaire par payeur") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter_CA()));
                      }

                      if (title == "Etat de retour") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter_Retour()));
                      }

                      if (title == "Chiffre d'affaire ShowRoom") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter_CA_SH()));
                      }



                    },);
                }).toList(),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Row getCardByTitle(String title) {
    String img = "";

    if (title == "Chiffre d'affaire par payeur")
      img = "assets/img_menu2/chiffre-daffaires.png";
    else if (title == "Stock")
      img = "assets/img_menu2/unite-de-gestion-des-stocks.png";
    else if (title == "Facture Non Payée")
      img = "assets/img_menu2/facturer.png";
    else if (title == "Etat de retour")
      img = "assets/img_menu2/boite-de-retour.png";
    else if (title == "Chiffre d'affaire ShowRoom")
      img = "assets/img_menu2/chiffre-daffaires1.png";




    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    img,
                    width: 45.w,
                    height: 45.w,
                  )
                ],
              )),
        ),
        SizedBox(width: 20,),
        Text(
          title,
          style: TextStyle(fontSize: 15.sp,
              fontWeight: FontWeight.bold,color: primaryColor),
          textAlign: TextAlign.center,

        ),
        Spacer(),

        IconButton(onPressed:(){

          if (title == "Stock") {
            setState(() {
              Global.NB_stock =0;
              Global.set_FamART_Stat("");
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Filter_Stock()));
          }

          if (title == "Facture Non Payée") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Filter_FA()));
          }
          if (title == "Chiffre d'affaire") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Filter_CA()));
          }

          if (title == "Etat de retour") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Filter_Retour()));
          }
        }
        , icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,))
      ],
    );
  }




  void scheduleRebuild() => setState(() {});


  bool isLoading = false;

  logout()  async {

    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String myUrl = BaseUrl.Login;
    http.post(Uri.parse(myUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${prefs.getString('Token')}',
        },
        body:{
          "email": prefs.getString('Login'),
          "password": prefs.getString('password'),

        }
    ).then((response) async {

      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      if(response.statusCode == 200){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FirstScreen()));

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('Login' );
        await prefs.remove('password' );
        await prefs.remove('Token');
        setState(() {
          isLoading = !isLoading;
        });

      }

    });

  }





}


