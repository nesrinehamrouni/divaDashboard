import 'dart:convert';

import 'package:divamobile/Models/M_conversations.dart';
import 'package:divamobile/Models/user.dart';
import 'package:divamobile/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Api.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  List<Conversation> conversations = [];
  bool isLoading = true;
  String? error;
  late int currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  

  Future<void> _initializeData() async {
    currentUserId = (await fetchCurrentUserId())!; // Fetch current user ID
    fetchConversations();
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


  Future<void> fetchConversations() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      String? token = await Utils.getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse(BaseUrl.url + '/chat/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> conversationsJson = json.decode(response.body);
        setState(() {
          conversations = conversationsJson.map((json) => Conversation.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load conversations: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (error != null) {
      return Center(child: Text('Error: $error'));
    } else if (conversations.isEmpty) {
      return _buildEmptyState();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            children: conversations.map((conversation) => buildConversationItem(conversation)).toList(),
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No conversations yet',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 170),
        ],
      ),
    );
  }

 Widget buildConversationItem(Conversation conversation) {
  User otherUser = conversation.user1.id == currentUserId ? conversation.user2 : conversation.user1;
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: InkWell(
      onTap: () {
        // Navigate to chat screen
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (top)
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              otherUser.image ?? 'https://via.placeholder.com/65',
              height: 65,
              width: 65,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: 65);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${otherUser.prenom} ${otherUser.nom}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF113953),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    conversation.lastMessage != null
                        ? conversation.lastMessage!.content
                        : 'No messages yet',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                conversation.lastMessage != null
                    ? _formatTime(conversation.lastMessage!.sentAt)
                    : '',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              SizedBox(height: 5),
              // You can add unread count here if needed
            ],
          ),
        ],
      ),
    ),
  );
}


  String _formatTime(String timeString) {
    final DateTime time = DateTime.parse(timeString).toLocal();
    final now = DateTime.now();
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      return DateFormat('HH:mm').format(time);
    } else if (time.year == now.year) {
      return DateFormat('dd/MM').format(time);
    } else {
      return DateFormat('dd/MM/yy').format(time);
    }
  }
}
