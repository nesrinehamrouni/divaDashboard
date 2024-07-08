import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../responsive.dart';
import 'login.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context) ? const SizedBox() : Expanded(
              child: Container(
                height: height,
                color: accentColor,
                child: Center(
                  child: Image(image: AssetImage('assets/images/Divalto_logo.png')),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: height-(120.h),
                    //margin: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isSmallScreen(context)? height * 0.032 : height * 0.12),
                    color: backColor,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: LoginBtn( isSmall:ResponsiveWidget.isSmallScreen(context)),
                    ),
                  ),
                 // Spacer() ,                // ),
                  Row(
                    children: [
                      SizedBox(width: 1,),
                      Spacer(),
                      Container(
                          height: 80.h,
                          margin: EdgeInsets.fromLTRB(20,20,10,20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Image(image: AssetImage('assets/images/logo_simsoft.png'), fit: BoxFit.fill)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
