
import 'dart:convert';

import 'package:divamobile/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/theme_helper.dart';
import '../../../../pages/widgets/header_widget.dart';
import '../../Api.dart';
import '../../Utils.dart';
import '../Menu/Menu.dart';
import '../registration_page.dart';


class Login extends StatefulWidget{
  final bool isSmall ;
  const Login({Key? key, required this.isSmall}): super(key:key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _UserXController = TextEditingController();
  bool _passwordVisible = true ;
  bool isLoading = false;

  

  @override
  Widget build(BuildContext context) {

    return
     isLoading ? Center(child:CircularProgressIndicator(),)
    :Column(
        children: [
          widget.isSmall ? Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
          ):Container(),
          SafeArea(
            child: Center(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      // Text(
                      //   'Hello',
                      //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      // ),
                      // Text(
                      //   'Signin into your account',
                      //   style: TextStyle(color: Colors.grey),
                      // ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: _UserXController,
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? "s'il vous plait entrer identifiant "
                                      : null,
                                  decoration: ThemeHelper().textInputDecoration('Nom', 'Entrer nom utilisateur'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                 // keyboardType: TextInputType.text,
                                  obscureText: _passwordVisible,
                                  controller: _passwordController,
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? "s'il vous plait entrer mot de passe "
                                      : null,
                                  decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  hintText: 'Entrer mot de passe',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                ),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(10,0,10,20),
                              //   alignment: Alignment.topRight,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                              //     },
                              //     child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Se connecter'.toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: (){
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                                    if (_formKey.currentState!.validate()) {
                                      login(_UserXController.text, _passwordController.text);

                                    }
                                  },
                                ),
                              ),
                              Container(
                                 margin: EdgeInsets.fromLTRB(10,20,10,20),
                                 child: Text.rich(
                                     TextSpan(
                                         children: [
                                           TextSpan(text: "Don\'t have an account? "),
                                           TextSpan(
                                             text: 'Create',
                                             recognizer: TapGestureRecognizer()
                                               ..onTap = (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                               },
                                             style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
                                           ),
                                         ]
                                     )
                                 ),

                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),
            ),
          ),
        ],

    );

  }

  login(String email, String password)  {
    setState(() {
      isLoading = true;
    });
    String myUrl = BaseUrl.Login;
    http.post(Uri.parse(myUrl),
        body:{
          "email": email,
          "password": password,

        }
    ).then((response) async {

      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      if(response.statusCode == 200){

        final data = jsonDecode(response.body);
        print('data ===== $data');
        print("data status code  ===== ${data['status_code']}");

        if(data['status_code'] == 200) {

          Utils.setToken(data['token']);
          print(data['token']);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Menu()), (route) => false);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('Login',email );
          await prefs.setString('password',password );
          await prefs.setString('Token',data['token'] );


          setState(() {
            isLoading = !isLoading;
          });

        } else {
          Fluttertoast.showToast(
              msg: "échec de la connexion s'il vous plait vérifier votre email ou mot de passe",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          setState(() {
            isLoading = !isLoading;
          });
        }
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
            child: ListBody(
              children: <Widget>[
                Text(" S’il vous plaît choisir représentant ou client."),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

