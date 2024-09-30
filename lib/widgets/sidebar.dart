import 'package:flutter/material.dart';
import 'package:greenroute/screens/feedback.dart';
import 'package:greenroute/screens/report.dart';
import 'package:greenroute/screens/support.dart';
import 'side_bar_menu.dart';
import '../controllers/loggout_controller.dart'; // Import logout controller
import 'logout_confirmation_dialog.dart'; // Import the logout confirmation dialog
import 'package:shared_preferences/shared_preferences.dart'; // Assuming you're using shared_preferences for storing user data

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    super.initState();
  }

  // Method to load user email from SharedPreferences (or any other data source)

  @override
  Widget build(BuildContext context) {
    final loggoutController =
        LoggoutController(); // Create instance of LoggoutController

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 31.0, bottom: 31.0, right: 20.0, left: 20.0),
        child: ListView(
          children: [
            GestureDetector(
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
            const SizedBox(height: 27),
            GestureDetector(
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
            const SizedBox(height: 27),
            GestureDetector(
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
            const SizedBox(height: 27),
            GestureDetector(
              onTap: () {
                showLogoutConfirmationDialog(
                    context, loggoutController); // Show confirmation dialog
              },
              child: const SideBarMenu(
                menuText: "Logout",
                menuIcon: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
