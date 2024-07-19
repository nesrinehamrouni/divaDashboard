
import 'dart:convert';

import 'package:divamobile/Models/api_response.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/constants.dart';
import 'package:http/http.dart' as http;

import '../Api.dart';

Future<ApiResponse> register(String nom,String prenom, String email,String phone, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(BaseUrl.Register),
      headers: {'Accept': 'application/json'}, 
      body: {
        'nom': nom,
        'prenom': prenom,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': password
      });
    switch(response.statusCode) {
      case 200:
        print('Registration successful');
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrongError;
        break;
    }
  }
  catch (e) {
    print('Exception caught: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;
}