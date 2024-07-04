
import 'dart:convert';

import 'package:divamobile/Models/api_response.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/constants.dart';
import 'package:http/http.dart' as http;

import '../Api.dart';

Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  print('aaaaa');
  print(BaseUrl.Register);
  try {
    final response = await http.post(
      
      Uri.parse(BaseUrl.Register),
      headers: {'Accept': 'application/json'}, 
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password
      });
  print(response.body);
    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
      print(response.body);
        apiResponse.error = somethingWentWrongError;
        
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
