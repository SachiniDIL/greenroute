import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeHeader extends StatefulWidget {
  final String userRole;
  final String userEmail;

  const HomeHeader({super.key, required this.userRole, required this.userEmail});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String firstName = 'User'; // Default first name

  @override
  void initState() {
    super.initState();
    _fetchFirstName(widget.userRole, widget.userEmail); // Fetch first name based on role and email
  }

  // Function to fetch first name from Firebase
  Future<void> _fetchFirstName(String userRole, String userEmail) async {
    String baseUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com';
    String endpoint = '';

    // Set the correct endpoint based on userRole
    if (userRole == 'resident') {
      endpoint = 'resident.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'truck_driver') {
      endpoint = 'truck_driver.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'disposal_officer') {
      endpoint = 'disposal_officer.json?orderBy="email"&equalTo="$userEmail"';
    }

    try {
      print('Fetching data for $userRole with email $userEmail');
      final url = Uri.parse('$baseUrl/$endpoint');  // Ensure the URL now has the endpoint
      print('Fetching from URL: $url'); // Log the full URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data.isNotEmpty) {
          final userData = data.values.first;
          setState(() {
            firstName = userData['first_name'] ?? 'User'; // Update firstName
          });
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching first name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 39.0),
          Image.asset("assets/app_name.png", height: 39),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,',
                      style: TextStyle(
                        color: Color(0xFF054700),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    _buildGreetingText(firstName, 15), // Display dynamic firstName
                    SizedBox(height: 10.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingText(String text, double fontSize) {
    return SizedBox(
      height: 23,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF5EA417),
          fontSize: fontSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
