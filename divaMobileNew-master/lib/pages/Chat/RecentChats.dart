import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../Api.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  List<dynamic> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(BaseUrl.url + '/chat/conversations'),
        headers: {
          'Authorization': 'dmmIJZP-SOyC--pZjljR__:APA91bF_k_wBBZtVMbCl_YJJzwsohyQ1nj_SVzPYusGQk4V7XOG3u70ZZUJ8h2oyddnET9Na5hchsEtqOM2Z5xpFmsRXCMEm0IleMUgE4IoHBasCLG2JFrMed2dEqS2jXOKfFLGM2TH1', // Replace with actual token
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          conversations = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load conversations: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : conversations.isEmpty
              ? Column(
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
                )
              : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) =>
                      buildConversationItem(conversations[index]),
                ),
    );
  }

  Widget buildConversationItem(dynamic conversation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          // Navigate to chat screen
        },
        child: Container(
          height: 65,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.network(
                  conversation['user']['photo'] ?? 'https://via.placeholder.com/65',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${conversation['user']['prenom']} ${conversation['user']['nom']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF113953),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        conversation['last_message']['content'],
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(conversation['last_message']['time']),
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  if (conversation['unread_count'] > 0)
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xFF113953),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        conversation['unread_count'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return '';
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
