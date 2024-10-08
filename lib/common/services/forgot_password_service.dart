import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class ForgotPasswordService {
  // Base URL for your Firebase Realtime Database
  final String firebaseBaseUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com';

  // Method to check if the entered email exists based on user role
  Future<bool> checkEmailExists(String email) async {
    try {
      // Retrieve user_role from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userRole = prefs.getString('user_role');

      if (userRole == null) {
        print("User role not found in shared preferences.");
        return false;
      }

      String endpoint = '';
      if (userRole == 'resident') {
        endpoint = 'resident.json?orderBy="email"&equalTo="$email"';
      } else if (userRole == 'truck_driver') {
        endpoint = 'truck_driver.json?orderBy="email"&equalTo="$email"';
      } else if (userRole == 'disposal_officer') {
        endpoint = 'disposal_officer.json?orderBy="email"&equalTo="$email"';
      } else {
        print("Unknown user role: $userRole");
        return false;
      }

      // Make the REST API call
      final url = Uri.parse('$firebaseBaseUrl/$endpoint');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // If no data is returned, the email doesn't exist
        if (data == null) {
          return false;
        }

        // Additional check for 'truck_driver' and 'disposal_officer' if 'signup' is true
        if (userRole == 'truck_driver' || userRole == 'disposal_officer') {
          bool isSignedUp = false;

          // Check if any user under truck_driver/disposal_officer has signup == true
          data.forEach((key, value) {
            if (value['signup'] == true) {
              isSignedUp = true;
            }
          });

          return isSignedUp;
        }

        // If data exists for 'resident', return true
        return true;
      } else {
        print('Error fetching email: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Error checking email: $e');
      return false;
    }
  }
}
