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
  String greeting = 'Good Morning'; // Default greeting

  @override
  void initState() {
    super.initState();
    _fetchFirstName(widget.userRole, widget.userEmail); // Fetch first name based on role and email
    _updateGreeting(); // Set greeting based on the time of day
  }

  // Function to update the greeting based on the time of the day
  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
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
      final url = Uri.parse('$baseUrl/$endpoint');
      print('Fetching from URL: $url');
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
                    Text(
                      greeting, // Display dynamic greeting
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
