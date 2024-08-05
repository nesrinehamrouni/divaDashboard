import 'dart:io';
import 'package:divamobile/Models/api_response.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/constants.dart';
import 'package:divamobile/pages/Login/firstScreen.dart';
import 'package:divamobile/pages/widgets/verificationCodePage.dart';
import 'package:divamobile/services/user_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import '../common/theme_helper.dart';
import '../pages/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool loading = false;
  bool checkboxValue = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _image;

  TextEditingController nameController = TextEditingController(),
      prenameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController(),
      verificationCodeController = TextEditingController();
      String? selectedRole;

  @override
  void dispose() {
    nameController.dispose();
    prenameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _registerUser() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a profile image'),
      ));
      return;
    }

    setState(() {
      loading = true;
    });
     print(
      "selectedRole"
    );

    String originalPhone = phoneController.text;

    ApiResponse response = await register(
      nameController.text,
      prenameController.text,
      emailController.text,
      originalPhone,
      passwordController.text,
      _image!,
      selectedRole ?? '',
    );

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Registration successful. Please check your email for verification.'),
        backgroundColor: Colors.green,
      ));
      _navigateToVerificationPage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _navigateToVerificationPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VerifyCodePage(
          email: emailController.text,
          verificationCode: verificationCodeController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 150,
                  child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            _buildProfileImagePicker(),
                            SizedBox(height: 30),
                            _buildTextFormField(
                              controller: nameController,
                              labelText: 'Nom',
                              hintText: 'Entrer votre nom',
                              validator: (val) =>
                                  val!.isEmpty ? 'Nom Invalide' : null,
                            ),
                            SizedBox(height: 30),
                            _buildTextFormField(
                              controller: prenameController,
                              labelText: 'Prénom',
                              hintText: 'Entrer votre prénom',
                              validator: (val) =>
                                  val!.isEmpty ? 'Prénom Invalide' : null,
                            ),
                            SizedBox(height: 20.0),
                            _buildTextFormField(
                              controller: emailController,
                              labelText: 'Adresse email',
                              hintText: 'Entrer votre adresse email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (!(val!.isEmpty) &&
                                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                  return "Entrer un email valide";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            _buildTextFormField(
                              controller: phoneController,
                              labelText: 'Numéro de téléphone',
                              hintText: 'Entrer votre numéro de téléphone',
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                if (val == null ||
                                    val.isEmpty ||
                                    val.length != 8 ||
                                    !RegExp(r"^\d+$").hasMatch(val)) {
                                  return "Entrer un numéro de téléphone valide";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            _buildTextFormField(
                              controller: passwordController,
                              labelText: 'Mot de passe',
                              hintText: 'Entrer votre mot de passe',
                              obscureText: true,
                              validator: (val) => val!.length < 6
                                  ? 'Required at least 6 chars'
                                  : null,
                            ),
                            SizedBox(height: 20),
                            _buildTextFormField(
                              controller: passwordConfirmController,
                              labelText: 'Confirmer le mot de passe',
                              hintText: 'Entrer votre mot de passe à nouveau',
                              obscureText: true,
                              validator: (val) => val != passwordController.text
                                  ? 'Confirm password does not match'
                                  : null,
                            ),
                            SizedBox(height: 20.0),
                              Container(
                                child: DropdownButtonFormField<String>(
                                  decoration: ThemeHelper().textInputDecoration('Rôle', 'Sélectionnez votre rôle'),
                                  value: selectedRole,
                                  items: <String>['Responsable', 'Admin'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRole = newValue;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Veuillez sélectionner un rôle' : null,
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                            SizedBox(height: 15.0),
                            _buildCheckboxFormField(),
                            SizedBox(height: 20.0),
                            _buildRegisterButton(),
                            _buildLoginText(),
                            SizedBox(height: 30.0),
                            _buildSocialMediaButtons(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (loading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 5, color: Colors.white),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      _image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: Colors.grey.shade300,
                    size: 80.0,
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey.shade700,
              size: 25.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: ThemeHelper().textInputDecoration(labelText, hintText),
      ),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }

  Widget _buildCheckboxFormField() {
    return FormField<bool>(
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: checkboxValue,
                  onChanged: (value) {
                    setState(() {
                      checkboxValue = value!;
                      state.didChange(value);
                    });
                  },
                ),
                Text(
                  "J'accepte les termes et conditions",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (state.hasError)
              Text(
                state.errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        );
      },
      validator: (value) {
        if (!checkboxValue) {
          return 'Vous devez accepter les termes et conditions';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            "S'inscrire".toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _registerUser();
          }
        },
      ),
    );
  }

  Widget _buildLoginText() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "Vous avez déjà un compte ? "),
            TextSpan(
              text: 'Se connecter',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FirstScreen()));
                },
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialMediaButton(
          icon: FontAwesomeIcons.googlePlus,
          color: HexColor("#EC2D2F"),
          onTap: () => _showSocialMediaDialog("Google Plus"),
        ),
        SizedBox(width: 30.0),
        _buildSocialMediaButton(
          icon: FontAwesomeIcons.twitter,
          color: HexColor("#40ABF0"),
          onTap: () => _showSocialMediaDialog("Twitter"),
          useContainer: true,
        ),
        SizedBox(width: 30.0),
        _buildSocialMediaButton(
          icon: FontAwesomeIcons.facebook,
          color: HexColor("#3E529C"),
          onTap: () => _showSocialMediaDialog("Facebook"),
        ),
      ],
    );
  }

  Widget _buildSocialMediaButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool useContainer = false,
  }) {
    return GestureDetector(
      child: useContainer
          ? Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 5, color: color),
                color: color,
              ),
              child: FaIcon(
                icon,
                size: 23,
                color: Colors.white,
              ),
            )
          : FaIcon(
              icon,
              size: 35,
              color: color,
            ),
      onTap: onTap,
    );
  }

  void _showSocialMediaDialog(String platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeHelper().alartDialog(
          platform,
          "You tap on $platform social icon.",
          context,
        );
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size: 100.0,
            ),
          ),
        ],
      ),
    );
  }
}