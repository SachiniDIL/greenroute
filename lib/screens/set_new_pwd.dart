import 'package:flutter/material.dart';
import 'package:greenroute/screens/r_login.dart';
import 'package:greenroute/widgets/button_large.dart';
import 'package:greenroute/widgets/button_small.dart';
import '../theme.dart'; // Assuming you have a theme file where AppColors and AppTextStyles are defined
import 'r_login.dart'; // Assuming you want to navigate to the login page after resetting the password

class SetNewPwd extends StatefulWidget {
  const SetNewPwd({super.key});

  @override
  _SetNewPwdState createState() => _SetNewPwdState();
}

class _SetNewPwdState extends State<SetNewPwd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Function to validate passwords
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Function to validate if both passwords match
  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Set New Password",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the previous page
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: AppColors.primaryColor, // Use your defined primary color
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Set New Password",
                    style: AppTextStyles.topic, // Custom text style from your theme
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create a new password. Ensure it differs from previous ones for security.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.50,
                    ), // Custom form text styling
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "New Password",
                    style: AppTextStyles.formText,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true, // Hide the password input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.buttonColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Enter new password',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    ),
                    validator: _validatePassword, // Password validation
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Password",
                    style: AppTextStyles.formText,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true, // Hide the password input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.buttonColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Confirm new password',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    ),
                    validator: _validateConfirmPassword, // Confirm password validation
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: BtnSmall(
                      buttonText: "Reset Password",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform reset password logic
                          print("Password reset successful");

                          // Navigate to the login page after password reset
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RLoginPage()),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
