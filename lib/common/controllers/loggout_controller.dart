// services/side_bar_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenroute/common/screens/select_role.dart'; // Import SelectRole screen

class LoggoutController {
  // Method to log out and navigate to SelectRole
  Future<void> logout(BuildContext context) async {
    // Update is_logged_in to false in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);

    // Navigate to SelectRole UI after logging out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SelectRole()),
          (Route<dynamic> route) => false, // Clears all previous routes
    );
  }
}
