import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:divamobile/Api.dart';
import 'package:divamobile/Notification/notif.dart';
import 'package:divamobile/pages/Menu/MenuBI.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils.dart';
import 'Login/firstScreen.dart';
import 'Menu/Menu.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  final NotificationSetUp _noti = NotificationSetUp();

  @override
  void initState() {
    super.initState();
    _noti.configurePushNotifications(context);
    _noti.eventListenerCallback(context);
    _getFirebaseToken();
    _initializeApp();
  _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage);
    }
  }

  void _handleNotification(RemoteMessage message) {
  print("Received notification: ${message.data}");
  if (message.data['target_page'] == 'tableau_de_bord') {
    print("Navigating to tableau_de_bord");
    _navigateToTableauDeBord();
  } else {
    print("Unknown or missing target_page/screen: ${message.data}");
    _navigateToTableauDeBord();
  }
}

  void _navigateToTableauDeBord() {
  // Use a slight delay to ensure the widget tree is built
  Future.delayed(Duration.zero, () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Menu_BI(),
    ));
  });
}
  
  Future<void> _getFirebaseToken() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        debugPrint("FCM Token: $token");
        await _sendTokenToServer(token);
      }
    }
  }

  Future<void> _sendTokenToServer(String token) async {
  try {
    final response = await http.post(
      Uri.parse(BaseUrl.Notify),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Utils.getToken()}',
      },
      body: jsonEncode(<String, String>{
        'fcm_token': token,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('FCM token successfully sent to server');
    } else {
      debugPrint('Failed to send FCM token to server. Status code: ${response.statusCode}');
      // Handle other status codes if needed
    }
  } catch (e) {
    debugPrint('Error sending FCM token to server: $e');
    // Handle network or other exceptions
  }
}


  void _initializeApp() {
    Timer(const Duration(milliseconds: 2000), () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('Login') != null) {
        if (prefs.getString('Token') != null) {
          setState(() {
            Utils.setToken(prefs.getString('Token'));
          });
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Menu()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FirstScreen()), (route) => false);
      }
      // await getNotif();
    });

    Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  // Future<void> getNotif() async {
  //   Notif_Function.notify();
  // }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Color(0xFF2f3b46),Color(0xFF2f3b46)],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child:  Image(image: AssetImage('assets/images/Divalto_logo.png'),
              )
          ),
        ),
      ),
    );
  }
}