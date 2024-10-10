import 'package:flutter/material.dart';
import 'package:greenroute/common/screens/feedback.dart';
import 'package:greenroute/common/screens/report.dart';
import 'package:greenroute/common/screens/support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../screens/login_or_signup.dart';
import 'side_bar_menu.dart';
import '../../common/controllers/loggout_controller.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? userRole; // Variable to hold the user role

  @override
  void initState() {
    super.initState();
    _loadUserRole(); // Load user role from SharedPreferences
  }

  // Method to load user role from SharedPreferences
  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role'); // Retrieve user role
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggoutController = LoggoutController(); // Create instance of LoggoutController

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 31.0, bottom: 31.0, right: 20.0, left: 20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
                child: const SideBarMenu(
                  menuText: "Feedback",
                  menuIcon: Icon(Icons.feedback),
                ),
              ),
            ),
            // Conditionally display "Report" menu item if the user role is not "resident"
            if (userRole != 'resident')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Report()),
                    );
                  },
                  child: const SideBarMenu(
                    menuText: "Report",
                    menuIcon: Icon(Icons.report),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Support()),
                  );
                },
                child: const SideBarMenu(
                  menuText: "Support",
                  menuIcon: Icon(Icons.support),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: GestureDetector(
                onTap: () {
                  _showLogoutConfirmationDialog(context); // Call the confirmation dialog
                },
                child: const SideBarMenu(
                  menuText: "Logout",
                  menuIcon: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',style: TextStyle(color: AppColors.primaryColor),),
            ),
            TextButton(
              onPressed: () async {
                // Clear user_email from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_email', 'null');

                // Navigate to the LoginSignup screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSignup()),
                      (Route<dynamic> route) => false, // Remove all routes in the stack
                );
              },
              child: const Text('Confirm', style: TextStyle(color: AppColors.primaryColor),),
            ),
          ],
        );
      },
    );
  }
}
