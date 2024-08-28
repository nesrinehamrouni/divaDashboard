import 'package:divamobile/Api.dart';
import 'package:divamobile/common/theme_helper.dart';
import 'package:divamobile/pages/Menu/Menu.dart';
import 'package:divamobile/pages/widgets/header_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;
  final String verificationCode; 
   final String selectedRole;
  VerifyCodePage({required this.email, required this.verificationCode,required this.selectedRole});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;

  Future<void> _verifyCode() async {
    if (_codeController.text == widget.verificationCode) {
      final response = await http.post(
        Uri.parse(BaseUrl.Verify),
        body: {
          'email': widget.email,
          'code': _codeController.text,
        },
      );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification successful')),
      );
      setState(() {
        _pinSuccess = true;
      });
       if (widget.selectedRole == 'Admin') {
          Navigator.pushReplacementNamed(context, '/Menu');
        } else if (widget.selectedRole == 'Responsable') {
          Navigator.pushReplacementNamed(context, '/responsableMenu');
        }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${response.body}')),
      );
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(
                _headerHeight,
                true,
                Icons.privacy_tip_outlined,
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Enter the verification code we just sent you on your email address.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          OTPTextField(
                            length: 6,
                            width: 300,
                            fieldWidth: 35,
                            style: TextStyle(fontSize: 30),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            keyboardType: TextInputType.text,
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'), // Allow letters and digits only
                              ),
                            ],
                            onCompleted: (pin) {
                              setState(() {
                                _pinSuccess = true;
                              });
                            },
                          ),
                          SizedBox(height: 50.0),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "If you didn't receive a code! ",
                                  style: TextStyle(color: Colors.black38),
                                ),
                                TextSpan(
                                  text: 'Resend',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle resend logic here
                                    },
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            decoration: _pinSuccess
                                ? ThemeHelper().buttonBoxDecoration(context)
                                : ThemeHelper().buttonBoxDecoration(
                                    context,
                                    "#AAAAAA",
                                    "#757575",
                                  ),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Verify".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: _pinSuccess
                                  ? () {
                                      _verifyCode();
                                      if (_codeController.text == widget.verificationCode) {
                                        if (widget.selectedRole == 'Admin') {
                                            Navigator.pushReplacementNamed(context, '/Menu');
                                          } else if (widget.selectedRole == 'Responsable') {
                                            Navigator.pushReplacementNamed(context, '/responsableMenu');
                                          }
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}