
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:divamobile/Notification/notif.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../Notification/notif_function.dart';
import '../../PièceFOU/PieceFou.dart';
import '../../Utils.dart';
import '../../constants.dart';
import '../../pieceCLI/PieceCLI.dart';
import '../Login/Choix_DOS_ETB.dart';
import '../Login/firstScreen.dart';
import 'MenuBI.dart';



class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final controller = DragSelectGridViewController();
  var taille ;

  @override
   initState()   {

    super.initState();
    controller.addListener(scheduleRebuild);

    getDOS_ETB();
    getAllnotif();

    // Initializing notification counter
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        NotificationController.notificationCounter = prefs.getInt('notification_counter') ?? 0;
      });
    });

     //listener to update the notification badge
    NotificationController.notificationListener = () {
      setState(() {});
    };

  }

  
  Future<void> getNotif() async {
    Notif_Function.notify();
  }

  Future<void> getDOS_ETB() async {
    final prefs = await SharedPreferences.getInstance();
    if( prefs.getString('DOS') != null){
      Global.set_DOS(prefs.getString('DOS')!);

    }
    if( prefs.getString('ETB') != null){

      Global.set_ETB(prefs.getString('ETB')!);
    }

  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }



  List<String> events = [

    "Consultation Pièces client",
    "Consultation Pièces Fournisseur",
    "Consultation des réglements",
    "Consultation des journaux",
    "Tableau de bord",

  ];

  int counter = 0 ;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home:  WillPopScope(
        onWillPop: () async => false,
        child: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          blurEffectIntensity: 4,
          progressIndicator:
          SpinKitFadingCircle(
            color: Colors.blue,
            size: 90.0.h,
          ),
          //LoadingBouncingGrid.square(backgroundColor: Colors.blue,size: 90,),
          dismissible: false,
          opacity: 0.8,
          color: Colors.black54,
          child: Scaffold(
            //backgroundColor: Color(0xff143361),
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
              // leading:  IconButton(
              //   icon:  Icon(Icons.arrow_back),
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Filter_CA()));
              //
              //   },
              // ),
             actions: [
               IconButton(onPressed: () async {
                 _showMyDialog();


               }, icon: Icon(Icons.manage_accounts_outlined,color: Colors.white,)),

               new Stack(
                 children: <Widget>[
                   new IconButton(icon: Icon(Icons.notifications), onPressed: () {
                     setState(() {
                       _shownotif();
                     });
                   }),
                   if (NotificationController.notificationCounter != 0)
                      Positioned(
                        right: 11,
                        top: 11,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                       constraints: BoxConstraints(
                         minWidth: 14,
                         minHeight: 14,
                       ),
                       child: Text(
                            '${NotificationController.notificationCounter}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                     ),
                   )
                 ],
               ),

               IconButton(onPressed: () async {

                 logout();

               }, icon: Icon(Icons.logout,color: Colors.white,)),
             ],

              title:Text("Menu"),


            ),
            body: ListView(
              children: <Widget>[


                Container(
                  height: 28.h,
                  child:  Align(alignment:Alignment.centerRight,
                      child: IconButton(onPressed: (){

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => FirstScreen()), (route) => false);
                      }, icon: Icon(Icons.logout,color: Colors.white,))),
                ),



                Container(
                  color: Colors.grey[100],
                  height: MediaQuery. of(context). size. height * 1.1,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: GridView(

                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    children: events.map((title) {
                      //loop all item in events list
                      return GestureDetector(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          //  color: Colors.blue[800],
                          margin:  EdgeInsets.all(15.r),
                          child: Container(
                            //height: 50.h,
                            // width: 150.w,
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(20),
                                //border: BorderSide(color: Colors.white70, width: 1),
                                // gradient: const LinearGradient(
                                //   colors: [
                                //     Color(0xFF5b6f82),
                                //     Color(0xFF424f5c),
                                //     Color(0xFF5b6f82),
                                //   ],
                                //   begin: Alignment.topLeft,
                                //   end: Alignment.bottomRight,
                                // ),
                              ),
                              child: getCardByTitle(title)//declare your widget here
                          ),
                        ),
                        onTap: () {


                          if (title == "Tableau de bord") {
                            setState(() {
                              Global.NB_stock =0;
                              Global.set_FamART_Stat("");
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Menu_BI()));
                          }

                          if (title == "Consultation des réglements") {

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Filter_FA()));
                          }
if (title == "Consultation Pièces client") {
  Navigator.push(
      context,
      MaterialPageRoute(
            builder: (context) => PieceCLI()));
                            }
if (title == "Consultation Pièces Fournisseur") {
  Navigator.push(
      context,
      MaterialPageRoute(
            builder: (context) => PieceFOU()));
                            }


                        },);
                    }).toList(),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCardByTitle(String title) {
    String img = "";

       if (title == "Tableau de bord")
      img = "assets/New_menu_img/Tableau_de_bord.png";
   else if (title == "Consultation des journaux")
      img = "assets/New_menu_img/billets-dargent.png";
       else if (title == "Consultation Pièces Fournisseur")
         img = "assets/New_menu_img/piece_fou1.png";
 else if (title == "Consultation Pièces client")
         img = "assets/New_menu_img/Piece_client.png";
 else if (title == "Consultation des réglements")
         img = "assets/New_menu_img/Piece_fou.png";




    return title == "Consultation des réglements" || title == "Consultation des journaux" ?
    Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        img,
                        width: 55.w,
                        height: 55.w,
                      )
                    ],
                  )),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 15.sp,
                  fontWeight: FontWeight.bold,color: primaryColor),
              textAlign: TextAlign.center,

            )
          ],
        ),
        Container(

          decoration: BoxDecoration(
            color: Colors.grey.shade400.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    )
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    img,
                    width: 55.w,
                    height: 55.w,
                  )
                ],
              )),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 15.sp,
              fontWeight: FontWeight.bold,color: primaryColor),
          textAlign: TextAlign.center,

        )
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

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FirstScreen()), (route) => false);

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




  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('champs vide'),
          content: const SingleChildScrollView(
            child: Choix_DOS_ETB()
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok',style: TextStyle(color: Colors.blue[600]!),),
              onPressed: () async {
                 final prefs = await SharedPreferences.getInstance();
                 await prefs.setString('DOS',Global.getDOS()! );
                 await prefs.setString('ETB',Global.getETB()! );
                 print("${Global.getETB()} ${Global.getDOS()}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool loadingNotif = false;


  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();

  Future<void> _shownotif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: Container(
           height: 200,
            width: 200,

            child: RefreshIndicator(

              onRefresh: getAllnotif,
              key: _refresh,
              child: loadingNotif
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                  child:Container(


                    child: ListView.builder(
                    itemCount: List_notif.length,

              shrinkWrap: true,
              itemBuilder: (context,index){

                return Container(
                  height: 40,
                  padding: EdgeInsets.all(5),
                  child: Card(

                      child: ListTile(
                        leading:  Image.asset(
                        List_notif[index]['IMPORTANCE']=='1' ?"assets/icons/warning.png":List_notif[index]['IMPORTANCE']=='2' ? "assets/icons/warning.png":"assets/icons/warning.png",
                          width: 20.w,
                          height: 20.w,
                        ),
                        title: Text(List_notif[index]['LIBL1'] ,
                        style: TextStyle( color:List_notif[index]['IMPORTANCE']=='2' ? Colors.orange : List_notif[index]['IMPORTANCE']=='3'? Colors.red : Colors.black54 ,
                        fontWeight: FontWeight.w500
                        ),
                        ),
                      ),

                  ),
                );
                    }
                    ),
                  )

              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok',style: TextStyle(color: Colors.blue[600]!),),
              onPressed: () async {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



var List_notif = [];


//   Future getAllnotif()  async {
// setState(() {
//   loadingNotif=true;
// });
  
//     http.post(Uri.parse(BaseUrl.Notify),
//         headers: {
//           HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
//         },
//         body: {


//           "DOS":Global.getDOS(),
//           "date":DateTime.now().toString(),

//         }).then((response) {
//       print('Response status : ${response.statusCode}');
//       print('Response body notif : ${response.body}');

//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         setState(() {
//           List_notif = jsonData;
//           //print(SousTypeCLItemlist);
//           counter = List_notif.length;
//           print("counter == ${counter}");
//         });

//       }
//       setState(() {
//         loadingNotif=false;
//       });
//     });

//   }


// }


 Future<void> getAllnotif() async {
    setState(() {
      loadingNotif = true;
    });

    final response = await http.post(
      Uri.parse(BaseUrl.Notify),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
      body: {
        "DOS": Global.getDOS(),
        "date": DateTime.now().toString(),
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body notif: ${response.body}');

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        List_notif = jsonData;
        counter = List_notif.length;
        print("counter == $counter");
      });
    }

    setState(() {
      loadingNotif = false;
    });
  }
}



