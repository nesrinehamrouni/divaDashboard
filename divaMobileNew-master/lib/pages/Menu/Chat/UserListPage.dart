import 'dart:convert';

import 'package:divamobile/Api.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/constants.dart';
import 'package:divamobile/pages/Menu/Chat/chatpage.dart';
import 'package:divamobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];
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
      Uri.parse(BaseUrl.getCurrentUserId),
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

      final response = await http.get(Uri.parse(BaseUrl.getUsers), headers: {
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: <Color>[accentColor, primaryColor],
            ),
          ),
        ),
        title: Text(
          'Select a User',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(users[index].nom![0]),
                      ),
                      title: Text(users[index].nom!),
                      subtitle: Text(users[index].email!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(userId: users[index].id!),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
