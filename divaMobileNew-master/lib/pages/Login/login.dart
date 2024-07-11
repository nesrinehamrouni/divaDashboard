import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../common/theme_helper.dart';
import '../../../../pages/widgets/header_widget.dart';
import '../../Api.dart';
import '../registration_page.dart';

class LoginBtn extends StatefulWidget {
  final bool isSmall;
  final Function(bool) onLoginStateChanged;

  const LoginBtn({
    Key? key,
    required this.isSmall,
    required this.onLoginStateChanged,
  }) : super(key: key);

  @override
  _LoginBtnState createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _passwordVisible = true;

  Future<void> _login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    print('Attempting login with email: $email and password: $password');

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.Login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['status_code'] == 200) {
          print('Login successful');
          _showSnackBar('Login successful', Colors.green);
          Navigator.pushReplacementNamed(context, '/Menu');
        } else if (responseBody['status_code'] == 401) {
          print('Login failed: Incorrect email or password');
          _showSnackBar("Adresse e-mail ou mot de passe incorrect.", Colors.red);
        } else if (responseBody['status_code'] == 404) {
          print('Login failed: User does not exist');
          _showSnackBar("L'utilisateur n'existe pas. Vérifiez votre saisie.", Colors.red);
        } else {
          print('Login failed with message: ${responseBody['message']}');
          _showSnackBar(responseBody['message'], Colors.red);
        }
      } else {
        print('Login failed with status code: ${response.statusCode}');
        _showSnackBar('Login failed with status code: ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      print('Login error: $e');
      _showSnackBar('Server error: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      widget.onLoginStateChanged(true);
      await _login();
      widget.onLoginStateChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isSmall)
          Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
          ),
        SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) =>
                            value!.isEmpty ? "S'il vous plaît entrer identifiant" : null,
                            decoration: ThemeHelper().textInputDecoration(
                                'Nom', 'Entrer nom utilisateur'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          child: TextFormField(
                            obscureText: _passwordVisible,
                            controller: passwordController,
                            validator: (value) =>
                            value!.isEmpty ? "S'il vous plaît entrer mot de passe" : null,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              hintText: 'Entrer mot de passe',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
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
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Se connecter'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: _handleLogin,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Vous n'avez pas de compte?",
                                    style: TextStyle(fontSize: 15)),
                                TextSpan(
                                  text: ' Inscrivez-vous !',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegistrationPage()),
                                      );
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}