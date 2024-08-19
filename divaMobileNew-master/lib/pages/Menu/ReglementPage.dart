import 'package:divamobile/Api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReglementPage extends StatefulWidget {
  @override
  _ReglementPageState createState() => _ReglementPageState();
}
Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
class _ReglementPageState extends State<ReglementPage> {
Future<List<Map<String, dynamic>>> _fetchReglements() async {
  final token = await getStoredToken(); // Implement this method to retrieve the stored token
  final response = await http.get(
    Uri.parse(BaseUrl.getReglements),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Parse the JSON data
    List<dynamic> data = json.decode(response.body);
    return data.map((item) {
      return {
        'num_piece': item['PINO'],
        'client': item['TIERS'],
        'htmt': double.tryParse(item['HTMT']) ?? 0.0,
      };
    }).toList();
  } else {
    print('Failed to load reglements: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load reglements');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation des règlements', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: <Color>[Colors.blue, Colors.green], // Replace with your colors
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchReglements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              final reglements = snapshot.data!;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue, // Replace with your color
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell('N° Pièce', flex: 2),
                            _buildHeaderCell('Client', flex: 3),
                            _buildHeaderCell('HTMT', flex: 2),
                          ],
                        ),
                      ),
                      ...reglements.map((reglement) => _buildDataRow(reglement)).toList(),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> reglement) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          _buildDataCell(reglement['num_piece'], flex: 2),
          _buildDataCell(reglement['client'], flex: 3),
          _buildDataCell('${reglement['htmt'].toStringAsFixed(2)} ', flex: 2),
         
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Text(
          text,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
