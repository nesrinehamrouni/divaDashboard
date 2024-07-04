
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;

// import '../../Api.dart';
// import '../../Utils.dart';
// import '../../common/theme_helper.dart';
// import '../profile_page.dart';
// import '../widgets/header_widget.dart';

// class LoginPage extends StatefulWidget{
//   const LoginPage({Key? key}): super(key:key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage>{
//   double _headerHeight = 250;
//   final _fromKey = GlobalKey<FormState>();

//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _UserXController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: _headerHeight,
//               child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
//             ),
//             SafeArea(
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                   margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
//                 child: Column(
//                   children: [
//                     // Text(
//                     //   'Hello',
//                     //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
//                     // ),
//                     // Text(
//                     //   'Signin into your account',
//                     //   style: TextStyle(color: Colors.grey),
//                     // ),
//                     SizedBox(height: 30.0),
//                     Form(
//                       key: _fromKey,
//                         child: Column(
//                           children: [
//                             Container(
//                               child: TextFormField(
//                                 controller: _UserXController,
//                                 validator: (value) =>
//                                 value!.isEmpty
//                                     ? "s'il vous plait entrer identifiant "
//                                     : null,
//                                 decoration: ThemeHelper().textInputDecoration('Nom', 'Entrer nom utilisateur'),
//                               ),
//                               decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                             ),
//                             SizedBox(height: 30.0),
//                             Container(
//                               child: TextFormField(
//                                 obscureText: true,
//                                 controller: _passwordController,
//                                 validator: (value) =>
//                                 value!.isEmpty
//                                     ? "s'il vous plait entrer un mot de passe "
//                                     : null,
//                                 decoration: ThemeHelper().textInputDecoration('Mot de passe', 'Entrer mot de passe'),
//                               ),
//                               decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                             ),
//                             SizedBox(height: 15.0),
//                             // Container(
//                             //   margin: EdgeInsets.fromLTRB(10,0,10,20),
//                             //   alignment: Alignment.topRight,
//                             //   child: GestureDetector(
//                             //     onTap: () {
//                             //       Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
//                             //     },
//                             //     child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
//                             //     ),
//                             //   ),
//                             // ),
//                             Container(
//                               decoration: ThemeHelper().buttonBoxDecoration(context),
//                               child: ElevatedButton(
//                                 style: ThemeHelper().buttonStyle(),
//                                 child: Padding(
//                                   padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
//                                   child: Text('Se connecter'.toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
//                                 ),
//                                 onPressed: (){

//                                   if (_fromKey.currentState!.validate()) {
//                                     login(_UserXController.text, _passwordController.text);

//                                   }
//                                 },
//                               ),
//                             ),
//                             // Container(
//                             //   margin: EdgeInsets.fromLTRB(10,20,10,20),
//                             //   //child: Text('Don\'t have an account? Create'),
//                             //   child: Text.rich(
//                             //     TextSpan(
//                             //       children: [
//                             //         TextSpan(text: "Don\'t have an account? "),
//                             //         TextSpan(
//                             //           text: 'Create',
//                             //           recognizer: TapGestureRecognizer()
//                             //             ..onTap = (){
//                             //               Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
//                             //             },
//                             //           style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
//                             //         ),
//                             //       ]
//                             //     )
//                             //   ),
//                             // ),
//                           ],
//                         )
//                     ),
//                     Image(image: AssetImage('assets/images/logo_simsoft.png'),
//                       width: 100,height: 55,),
//                   ],
//                 )
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//   }


//   login(String email, String password)  {
//     // setState(() {
//     //   isLoading = true;
//     // });
//     String myUrl = BaseUrl.Login;
//     http.post(Uri.parse(myUrl),
//         body:{
//           "email": email,
//           "password": password,

//         }
//     ).then((response) {

//       print('Response status : ${response.statusCode}');
//       print('Response body : ${response.body}');
//       if(response.statusCode == 200){

//         final data = jsonDecode(response.body);
//         print('data ===== $data');
//         print("data status code  ===== ${data['status_code']}");

//         if(data['status_code'] == 200) {

//           Utils.setToken(data['token']);
//           print(data['token']);

//           Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ProfilePage()));

//           // setState(() {
//           //   isLoading = !isLoading;
//           // });

//         } else {
//           Fluttertoast.showToast(
//               msg: "échec de la connexion s'il vous plait vérifier votre email ou mot de passe",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0
//           );
//           // setState(() {
//           //   isLoading = !isLoading;
//           // });
//         }
//       }
//     });

//   }
// }



