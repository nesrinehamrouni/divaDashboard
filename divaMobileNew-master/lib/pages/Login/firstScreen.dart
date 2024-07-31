import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../responsive.dart';
import 'login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';


class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
    bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: backColor,
        body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!ResponsiveWidget.isSmallScreen(context))
                  Expanded(
                    child: Container(
                      height: height,
                      color: accentColor,
                      child: Center(
                        child: Image(image: AssetImage('assets/images/Divalto_logo.png')),
                      ),
                    ),
                  ),
                 // Spacer() ,                // ),
                  Expanded(
                  child: Column(
                     children: [
                    Container(
  height: height - (120.h),
                        color: backColor,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: LoginBtn(
                            isSmall: ResponsiveWidget.isSmallScreen(context),
                            onLoginStateChanged: (bool isLoggingIn) {
                              setState(() {
                                _isLoggingIn = isLoggingIn;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 1),
                          Spacer(),
                          Container(
                            height: 80.h,
                            margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
                            child: Image(
                              image: AssetImage('assets/images/logo_simsoft.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
   ),
              ],
            ),
          ),
          if (_isLoggingIn)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 100.0,
                  ),
                ),
              ),
            ),
                    ],
                          ),
    );
  }
}

                  