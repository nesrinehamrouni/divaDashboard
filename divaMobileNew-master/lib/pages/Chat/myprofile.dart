import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.getAllUsers),
        headers: {
          'Authorization': 'dmmIJZP-SOyC--pZjljR__:APA91bF_k_wBBZtVMbCl_YJJzwsohyQ1nj_SVzPYusGQk4V7XOG3u70ZZUJ8h2oyddnET9Na5hchsEtqOM2Z5xpFmsRXCMEm0IleMUgE4IoHBasCLG2JFrMed2dEqS2jXOKfFLGM2TH1', // Replace with actual token
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        print('Decoded data: $decodedData');
        setState(() {
          users = decodedData;
          isLoading = false;
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
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

  Widget buildUserProfile(dynamic user) {
    print('User data: $user'); // This will print all available data for each user

    return Padding(
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
              child: Icon(Icons.person, size: 65, color: Colors.grey),
            ),
          ),
          SizedBox(height: 5),
          Text(
            user['nom'] ?? 'User',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            user['prenom'] ?? user['email'] ?? 'No details', // Fallback to email if prenom is null
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
