import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String baseUrl =
      "https://greenroute-7251d-default-rtdb.firebaseio.com";

  // Validate user credentials based on role (resident, truck_driver, disposal_officer)
  Future<String?> validateUser(String emailOrUsername, String password) async {
    // Get user role from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('user_role');

    if (userRole == null) {
      // User role not set
      return null;
    }

    String node;
    if (userRole == 'resident') {
      node = 'resident'; // Check in 'resident' node
    } else if (userRole == 'truck_driver') {
      node =
          'truck_driver'; // Check in 'truck_driver' node where signup is true
    } else if (userRole == 'disposal_officer') {
      node =
          'disposal_officer'; // Check in 'disposal_officer' node where signup is true
    } else {
      return null; // Invalid user role
    }

    try {
      // Fetch data from the respective node
      final response = await http.get(Uri.parse('$baseUrl/$node.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        for (var entry in data.entries) {
          final user = entry.value;

          // Check email or username match
          if ((user['email'] == emailOrUsername ||
              user['username'] == emailOrUsername)) {
            // For truck_driver and disposal_officer, ensure signup is true
            if (userRole != 'resident' && user['signup'] != true) {
              continue;
            }

            // Check password match
            if (user['password'] == password) {
              return user['email']; // Return valid user's email
            }
          }
        }
      }

      return null; // No valid user found
    } catch (e) {
      print('Error validating user: $e');
      return null;
    }
  }
}
