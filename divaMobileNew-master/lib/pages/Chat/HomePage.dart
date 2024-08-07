import 'dart:convert';

import 'package:divamobile/Api.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/Utils.dart';
import 'package:divamobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'RecentChats.dart';
import 'myprofile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allUsers = [];
  List<dynamic> users = [];
  List<Map<String, dynamic>> displayedUsers = [];
  bool isLoading = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

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
            allUsers = fetchedUsers.map((user) {
              return {
                'id': user.id,
                'nom': user.nom,
                'prenom': user.prenom,
                'profile_image': user.image, // Assuming 'image' contains profile image URL
              };
            }).toList();
            displayedUsers = allUsers;
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

  void searchUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        displayedUsers = allUsers;
      } else {
        isSearching = true;
        displayedUsers = allUsers.where((user) {
          final fullName = "${user['prenom']} ${user['nom']}".toLowerCase();
          return fullName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:Colors.white), // Or Icons.menu if using with Drawer
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Color(0xFFF5F5F3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Color(0xFF11395F),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                            onChanged: searchUsers,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Color(0xFF113953),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Increased space between search bar and results
                Expanded(
                  child: isSearching
                      ? ListView.builder(
                          itemCount: displayedUsers.length,
                          itemBuilder: (context, index) {
                            final user = displayedUsers[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30, // Larger image
                                    backgroundImage: NetworkImage(
                                      user['profile_image'] ??
                                          'https://example.com/default_profile.png', // Replace with your actual default image URL
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      "${user['prenom']} ${user['nom']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            MyProfile(),
                            RecentChats(),
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
