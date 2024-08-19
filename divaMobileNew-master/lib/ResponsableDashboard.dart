
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:divamobile/Utils.dart';
import 'package:divamobile/pages/Login/Choix_DOS_ETB.dart';
import 'package:divamobile/pages/Login/firstScreen.dart';
import 'package:divamobile/pages/Menu/Chat/UserListPage.dart';
import 'package:divamobile/pages/Menu/ReglementPage.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../My_globals.dart';
import '../../PièceFOU/PieceFou.dart';
import '../../constants.dart';
import '../../pieceCLI/PieceCLI.dart';



class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final controller = DragSelectGridViewController();
  var taille ;
  int counter = 0;
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;
  Timer? _timer;

  @override
   initState()   {

    super.initState();

    getDOS_ETB();
    // Initial fetch
    fetchNotifications();
    // Set up timer for periodic fetches
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      fetchNotifications();
    });
    
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


 Future<void> fetchNotifications() async {
  setState(() {
    isLoading = true;
  });

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final url = BaseUrl.getNotifications;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final List<dynamic> notificationData = json.decode(response.body);
      if (notificationData.isNotEmpty) {
        setState(() {
          notifications.add(Map<String, dynamic>.from(notificationData[0]));
          counter = notifications.length; // All notifications in the list are unread
        });
      }
    } else if (response.statusCode == 401) {
      print('Unauthorized access. Token may be invalid or expired.');
    } else {
      throw HttpException('Failed to load notification. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching notification: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

 void _shownotif() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Notifications'),
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : notifications.isEmpty
                      ? Center(child: Text('No notifications'))
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Dismissible(
                              key: Key(notification['MNOTIFICATION_ID'].toString()),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setDialogState(() {
                                  removeNotification(notification['MNOTIFICATION_ID'].toString());
                                });
                              },
                              child: ListTile(
                                title: Text(notification['LIBL1'] ?? 'No title'),
                                subtitle: Text(notification['AFFICHAGETPV'] ?? 'No content'),
                                tileColor: Colors.yellow[100],
                                onTap: () {
                                  setDialogState(() {
                                    removeNotification(notification['MNOTIFICATION_ID'].toString());
                                  });
                                },
                              ),
                            );
                          },
                        ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void removeNotification(String notificationId) {
  setState(() {
    notifications.removeWhere((n) => n['MNOTIFICATION_ID'].toString() == notificationId);
    counter = notifications.length;
  });
}


  @override
  void dispose() {
    _timer?.cancel();
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }



  List<String> events = [

    "Consultation Pièces client",
    "Consultation Pièces Fournisseur",
    "Consultation des réglements",
    "Consultation des journaux",
  

  ];




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
            actions: [
              IconButton(onPressed: () async {
                _showMyDialog();


              }, icon: Icon(Icons.manage_accounts_outlined,color: Colors.white,)),

              new Stack(
                children: <Widget>[
                  new IconButton(icon: Icon(Icons.notifications, color: Colors.white, ), onPressed: () {
                    setState(() {
                      _shownotif();
                    });
                  }),
                  counter != 0 ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) : new Container()
                ],
              ),

              IconButton(onPressed: () async {
                logout();
              }, icon: Icon(Icons.logout,color: Colors.white,)),
            ],

              title: Text("Menu", style: TextStyle(color: Colors.white)),


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
                          margin:  EdgeInsets.all(15.r),
                          child: Container(
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(20), 
                              ),
                              child: getCardByTitle(title)//declare your widget here
                          ),
                        ),
                        onTap: () {
                          
                          if (title == "Consultation des réglements") {

                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => ReglementPage()));
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
                                                      } },);
                                              }).toList(),
                                            ),
                                          ),


                          ],
                          ),
                            floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserListPage()),
                              );
                            },

                              child: Icon(Icons.chat),
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              ),
                              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }

  Widget getCardByTitle(String title) {
    String img = "";
if (title == "Consultation des journaux")
      img = "assets/New_menu_img/billets-dargent.png";
       else if (title == "Consultation Pièces Fournisseur")
         img = "assets/New_menu_img/piece_fou1.png";
 else if (title == "Consultation Pièces client")
         img = "assets/New_menu_img/Piece_client.png";
 else if (title == "Consultation des réglements")
         img = "assets/New_menu_img/Piece_fou.png";




    return title == "Consultation des journaux" ?
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


 Future<void> logout() async {
  try {
    String? token = await Utils.getToken();
    print('Token for logout: $token');

    if (token == null) {
      print('No token found, user is already logged out');
      await _handleLogoutSuccess();
      return;
    }

    final response = await http.post(
      Uri.parse('${BaseUrl.Logout}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('Logout response status: ${response.statusCode}');
    print('Logout response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Logout successful');
      await _handleLogoutSuccess();
    } else if (response.statusCode == 401) {
      print('User not authenticated on server, clearing local data');
      await _handleLogoutSuccess();
    } else {
      print('Logout failed: ${response.body}');
    }
  } catch (e) {
    print('Error during logout: $e');
    print('Stack trace: ${StackTrace.current}');
  }
}

Future<void> _handleLogoutSuccess() async {
  await Utils.clearToken();
  Navigator.push(context, MaterialPageRoute(builder: (context) => FirstScreen()));
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

  // bool loadingNotif = false;


  // final GlobalKey<RefreshIndicatorState> _refresh =
  // GlobalKey<RefreshIndicatorState>();

  // Future<void> _shownotif() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Notifications'),
  //         content: Container(
  //          height: 200,
  //           width: 200,

  //           child: RefreshIndicator(

  //             onRefresh: getAllnotif,
  //             key: _refresh,
  //             child: loadingNotif
  //                 ? Center(child: CircularProgressIndicator())
  //                 : SingleChildScrollView(
  //                 child:Container(


  //                   child: ListView.builder(
  //                   itemCount: List_notif.length,

  //             shrinkWrap: true,
  //             itemBuilder: (context,index){

  //               return Container(
  //                 height: 40,
  //                 padding: EdgeInsets.all(5),
  //                 child: Card(

  //                     child: ListTile(
  //                       leading:  Image.asset(
  //                       List_notif[index]['IMPORTANCE']=='1' ?"assets/icons/warning.png":List_notif[index]['IMPORTANCE']=='2' ? "assets/icons/warning.png":"assets/icons/warning.png",
  //                         width: 20.w,
  //                         height: 20.w,
  //                       ),
  //                       title: Text(List_notif[index]['LIBL1'] ,
  //                       style: TextStyle( color:List_notif[index]['IMPORTANCE']=='2' ? Colors.orange : List_notif[index]['IMPORTANCE']=='3'? Colors.red : Colors.black54 ,
  //                       fontWeight: FontWeight.w500
  //                       ),
  //                       ),
  //                     ),

  //                 ),
  //               );
  //                   }
  //                   ),
  //                 )

  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child:  Text('ok',style: TextStyle(color: Colors.blue[600]!),),
  //             onPressed: () async {

  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // void _shownotif() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Notifications'),
  //         content: Container(
  //           width: double.maxFinite,
  //           child: ListView.builder(
  //             itemCount: notifications.length,
  //             itemBuilder: (context, index) {
  //               final notification = notifications[index];
  //               return ListTile(
  //                 title: Text(notification['LIBL1']),
  //                 subtitle: Text(notification['AFFICHAGETPV']),
  //                 onTap: () {
  //                   // No need to mark as read here, as the backend does it automatically
  //                   Navigator.of(context).pop();
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // Refresh notifications after closing the dialog
  //               fetchNotifications();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }




  // var List_notif = [];


//   Future getAllnotif()  async {
// setState(() {
//   loadingNotif=true;
// });
//     http.post(Uri.parse(BaseUrl.getNotifications),
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


}