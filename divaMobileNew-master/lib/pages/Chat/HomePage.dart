// import 'RecentChats.dart';
// import 'myprofile.dart';
// import 'package:flutter/material.dart';
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(),
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Icon(Icons.notifications),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 10,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12, // Lighter shadow color for subtle effect
//                   blurRadius: 5.0,
//                   spreadRadius: 2.0,
//                   offset: Offset(0, 3), // Slight downward shadow
//                 ),
//               ],
//               color: Color(0xFFF5F5F3),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
//                   child: Text(
//                     "Messages",
//                     style: TextStyle(
//                       color: Color(0xFF11395F), // Corrected color code
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: 300,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15),
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 hintText: "Search",
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           Icons.search,
//                           color: Color(0xFF113953),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 MyProfile(),
//                 RecentChats(),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Color(0xFF113953),
//         child: Icon(Icons.add,
//             color: Colors.white
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RecentChats.dart';
import 'myprofile.dart';
import '../../Api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> displayedUsers = [];
  bool isLoading = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

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
          'Authorization': 'Bearer YOUR_AUTH_TOKEN_HERE', // Replace with actual auth token
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          allUsers = List<Map<String, dynamic>>.from(data);
          displayedUsers = allUsers;
          isLoading = false;
        });
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 10,
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
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30, // Larger image
                                    backgroundImage: NetworkImage(
                                      user['profile_image'] ?? 'https://example.com/default_profile.png',
                                      // Replace with your actual default image URL
                                    ),
                                    onBackgroundImageError: (_, __) {
                                      // Fallback to default image on error
                                      setState(() {
                                        user['profile_image'] = 'https://example.com/default_profile.png';
                                      });
                                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF113953),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}