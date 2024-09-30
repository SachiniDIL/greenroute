import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<bool> validateUser(String email, String password) async {
    // Get user role from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('user_role');

    if (userRole == null) {
      // User role not set
      return false;
    }

    try {
      // Query the database based on the user role (resident or truck_driver)
      final role = userRole == 'resident' ? 'resident' : 'truckdriver';

      // Query the database for the email, password, and role
      final snapshot = await databaseReference
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      // Check if the user exists and their credentials match
      if (snapshot.snapshot.value != null) {
        final users = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        for (var user in users.values) {
          if (user['password'] == password && user['role'] == role) {
            // Login successful
            return true;
          }
        }
      }

      // No matching user found
      return false;
    } catch (e) {
      // Error occurred while querying the database
      print('Error validating user: $e');
      return false;
    }
  }
}
