import 'package:flutter/material.dart';
import 'package:greenroute/controllers/loggout_controller.dart';

import '../theme.dart'; // Import the logout controller

// Function to display the logout confirmation dialog
void showLogoutConfirmationDialog(BuildContext context, LoggoutController loggoutController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'poppins'
          ),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'poppins'
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on cancel
            },
          ),
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'poppins'
              ),
            ),
            onPressed: () {
              loggoutController.logout(context); // Logout when user confirms
            },
          ),
        ],
      );
    },
  );
}
