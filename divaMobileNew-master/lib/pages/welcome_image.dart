import 'package:flutter/material.dart';


import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Image(image: AssetImage('assets/images/Divalto_logo.png'),
      ),
    );
  }
}