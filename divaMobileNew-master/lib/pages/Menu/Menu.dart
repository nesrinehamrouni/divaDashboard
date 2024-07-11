import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  bool isLoading = false;

  @override
  void initState() {
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

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  Future<void> getDOS_ETB() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('DOS') != null) {
      Global.set_DOS(prefs.getString('DOS')!);
    }
    if (prefs.getString('ETB') != null) {
      Global.set_ETB(prefs.getString('ETB')!);
    }
  }

  List<String> events = [
    "Consultation Pièces client",
    "Consultation Pièces Fournisseur",
    "Consultation des réglements",
    "Consultation des journaux",
    "Tableau de bord",
  ];

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => false,
        child: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          blurEffectIntensity: 4,
          progressIndicator: SpinKitFadingCircle(
            color: Colors.blue,
            size: 90.0.h,
          ),
          dismissible: false,
          opacity: 0.8,
          color: Colors.black54,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: <Color>[accentColor, primaryColor],
                  ),
                ),
              ),
              titleSpacing: 20.0,
              actions: [
                IconButton(
                  onPressed: () async {
                    _showMyDialog();
                  },
                  icon: Icon(Icons.manage_accounts_outlined, color: Colors.white),
                ),
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _shownotif();
                        });
                      },
                    ),
                    if (counter != 0)
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
                            '$counter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    logout();
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                ),
              ],
              title: Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  color: Colors.grey[100],
                  height: MediaQuery.of(context).size.height * 1.1,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: GridView(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    children: events.map((title) {
                      return GestureDetector(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          margin: EdgeInsets.all(15.r),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: getCardByTitle(title),
                          ),
                        ),
                        onTap: () {
                          if (title == "Tableau de bord") {
                            setState(() {
                              Global.NB_stock = 0;
                              Global.set_FamART_Stat("");
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Menu_BI()));
                          } else if (title == "Consultation Pièces client") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PieceCLI()));
                          } else if (title == "Consultation Pièces Fournisseur") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PieceFOU()));
                          }
                          // Add other navigation logic for remaining menu items
                        },
                      );
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

    return title == "Consultation des réglements" || title == "Consultation des journaux"
        ? Stack(
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
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: primaryColor),
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
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: primaryColor),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void scheduleRebuild() => setState(() {});

  Future<void> logout() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token');

    if (token == null) {
      await _clearLocalData();
      _navigateToLoginScreen();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.Logout),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await _clearLocalData();
        _navigateToLoginScreen();
      } else {
        print('Logout failed: ${response.body}');
        // Show an error message to the user
      }
    } catch (e) {
      print('Error during logout: $e');
      // Show an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('Login');
    await prefs.remove('password');
    await prefs.remove('Token');
    await prefs.remove('DOS');
    await prefs.remove('ETB');
    // Clear any other relevant data
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => FirstScreen()),
          (route) => false,
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir DOS et ETB'),
          content: const SingleChildScrollView(
              child: Choix_DOS_ETB()
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.blue[600]!)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('DOS', Global.getDOS()!);
                await prefs.setString('ETB', Global.getETB()!);
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
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _shownotif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                  : ListView.builder(
                itemCount: List_notif.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset(
                          List_notif[index]['IMPORTANCE'] == '1'
                              ? "assets/icons/warning.png"
                              : List_notif[index]['IMPORTANCE'] == '2'
                              ? "assets/icons/warning.png"
                              : "assets/icons/warning.png",
                          width: 20.w,
                          height: 20.w,
                        ),
                        title: Text(
                          List_notif[index]['LIBL1'],
                          style: TextStyle(
                            color: List_notif[index]['IMPORTANCE'] == '2'
                                ? Colors.orange
                                : List_notif[index]['IMPORTANCE'] == '3'
                                ? Colors.red
                                : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.blue[600]!)),
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

  Future getAllnotif() async {
    setState(() {
      loadingNotif = true;
    });

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.get_Notification),
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
      } else {
        // Handle error
        print('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching notifications: $e');
    } finally {
      setState(() {
        loadingNotif = false;
      });
    }
  }
}