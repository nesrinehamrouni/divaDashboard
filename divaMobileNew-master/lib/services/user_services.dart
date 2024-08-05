import 'dart:convert';
import 'dart:io';

import 'package:divamobile/Models/api_response.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../Api.dart';

Future<ApiResponse> register(String nom, String prenom, String email, String phone, String password, File image, String role) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    var request = http.MultipartRequest('POST', Uri.parse(BaseUrl.Register));
    request.fields['nom'] = nom;
    request.fields['prenom'] = prenom;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['role'] = role ;
  

    var pic = await http.MultipartFile.fromPath('profile_image', image.path, contentType: MediaType('image', 'jpeg'));
    request.files.add(pic);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var jsonResponse = jsonDecode(response.body);

    switch(response.statusCode) {
      case 200:
        print('Registration successful');
        if (jsonResponse['user'] != null) {
          apiResponse.data = User.fromJson(jsonResponse['user']);
        } else {
          apiResponse.error = 'User data not found in response';
        }
        break;
      case 422:
      case 500:
        String errorMessage = jsonResponse['error'] ?? 'An unknown error occurred';
        if (errorMessage.contains('email has already been taken')) {
          apiResponse.error = 'This email is already registered';
        } else if (errorMessage.contains('phone has already been taken')) {
          apiResponse.error = 'This phone number is already registered';
        } else {
          apiResponse.error = errorMessage;
        }
        break;
      default:
        apiResponse.error = 'Status code: ${response.statusCode}, Body: ${response.body}';
        break;
    }
  }
  catch (e) {
    print('Exception caught: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;
}