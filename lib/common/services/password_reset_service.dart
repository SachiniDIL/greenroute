import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class PasswordResetService {
  // Base URL for your Firebase Realtime Database
  final String firebaseBaseUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com';

  // Method to update the password based on the user role
  Future<void> updatePassword(String email, String newPassword) async {
    try {
      // Retrieve user_role from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userRole = prefs.getString('user_role');

      if (userRole == null) {
        throw Exception("User role not found in shared preferences.");
      }

      String endpoint = '';
      if (userRole == 'resident') {
        endpoint = 'resident.json?orderBy="email"&equalTo="$email"';
      } else if (userRole == 'truck_driver') {
        endpoint = 'truck_driver.json?orderBy="email"&equalTo="$email"';
      } else if (userRole == 'disposal_officer') {
        endpoint = 'disposal_officer.json?orderBy="email"&equalTo="$email"';
      } else {
        throw Exception("Unknown user role: $userRole");
      }

      // Fetch the record to be updated
      final url = Uri.parse('$firebaseBaseUrl/$endpoint');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // If no data is returned, the email doesn't exist
        if (data == null || data.isEmpty) {
          throw Exception('Email does not exist.');
        }

        // Get the key for the user
        String userKey = data.keys.first;

        // Update the password for the specific user record
        final updateUrl = Uri.parse('$firebaseBaseUrl/$userRole/$userKey.json');
        final updateResponse = await http.patch(
          updateUrl,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'password': newPassword}),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception('Failed to update password.');
        }
      } else {
        throw Exception('Failed to fetch user data.');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error updating password: $e');
    }
  }
}
