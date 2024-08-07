import 'package:flutter/material.dart';

import 'ComponentsBody.dart';

class ConversationScreen extends StatelessWidget {
  final int userId;
  final String userName;
  final String? userProfileImage;

  ConversationScreen({
    required this.userId,
    required this.userName,
    this.userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: userProfileImage != null
                      ? NetworkImage(userProfileImage!)
                      : AssetImage("assets/images/Divalto_logo.png")
                          as ImageProvider,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      "Online", // You can replace this with the user's status
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: ComponentsBody(userId: userId), // Pass the userId to ComponentsBody
    );
  }
}
