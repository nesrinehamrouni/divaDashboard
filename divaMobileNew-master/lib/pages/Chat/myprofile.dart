import 'dart:convert';

import 'package:divamobile/Models/user.dart';
import 'package:divamobile/Utils.dart';
import 'package:divamobile/pages/Chat/ConverstationScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Api.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<int?> fetchCurrentUserId() async {
    try {
    String? token = await Utils.getToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.get(
      Uri.parse(BaseUrl.GetCurrentUserId),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
      if (jsonResponse['user_id'] != null) {
        return jsonResponse['user_id'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: ${response.body}');
      } else {
        throw Exception('Failed to load current user id');
      }
    } catch (e) {
      print('Error fetching current user id: $e');
      throw Exception('Failed to fetch current user id');
    }
  }

  Future<void> fetchUsers() async {
    try {
      // Fetch current user ID
      int? currentUserId = await fetchCurrentUserId();

      final response = await http.get(Uri.parse(BaseUrl.GetUsers), headers: {
        'Accept': 'application/json',
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<User> fetchedUsers = [];

        // Parse the JSON response safely
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          fetchedUsers =
              jsonResponse.map((data) => User.fromJson(data)).toList();

          // Filter out the current user from fetchedUsers
          fetchedUsers.removeWhere((user) => user.id == currentUserId);

          fetchedUsers.sort((a, b) => a.nom!.compareTo(b.nom!));

          setState(() {
            users = fetchedUsers;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 5),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: users.map((user) => buildUserProfile(user)).toList(),
              ),
            ),
    );
  }

 Widget buildUserProfile(User user) {
  print('User data: $user'); // This will print all available data for each user

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            userId: user.id!,
            userName: user.nom ?? user.prenom ?? 'User',
            userProfileImage: user.image,
          ),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: user.image != null
                  ? Image.network(user.image!)
                  : Icon(Icons.person, size: 65, color: Colors.grey),
            ),
          ),
          SizedBox(height: 5),
          Text(
            user.nom ?? user.prenom ?? 'User',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            user.prenom ?? user.nom ?? user.email ?? 'No details',
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
}