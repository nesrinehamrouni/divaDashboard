import 'dart:async';

import 'package:divamobile/Notification/notif_function.dart';

import '../Utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  _SplashScreenState(){

    Timer(const Duration(milliseconds: 2000), (){
      setState(() async {
        final prefs = await SharedPreferences.getInstance();
        if( prefs.getString('Login') != null){

          if( prefs.getString('Token') != null){
            setState(() {
              Utils.setToken(prefs.getString('Token'))  ;


            });
          }

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Menu()), (route) => false);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FirstScreen()), (route) => false);
        }
        getNotif();
      });
    });

    Timer(
      Duration(milliseconds: 10),(){
        setState(() {
          _isVisible = true; // Now it is showing fade effect and navigating to Login page
        });
      }
    );

  }

  Future<void> getNotif() async {
    Notif_Function.notify();
  }

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