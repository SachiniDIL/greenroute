import 'package:flutter/material.dart';
import 'forgot_password.dart'; // Import the new ForgotPasswordPage
import 'resident_home.dart'; // Import your resident home page
import '../theme.dart'; // Import your custom theme
import '../widgets/button_large.dart'; // Import the custom button

class RLoginPage extends StatefulWidget {
  const RLoginPage({super.key});

  @override
  _RLoginPageState createState() => _RLoginPageState();
}

class _RLoginPageState extends State<RLoginPage> {
  bool _obscurePassword = true; // Password visibility toggle

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login page",
      home: Scaffold(
        body: SingleChildScrollView( // Makes the content scrollable
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Adjust for spacing
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigates back to the previous page
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign In",
                  style: AppTextStyles.topic,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Username or Email",
                  style: AppTextStyles.formText,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor, // Set the color of the border
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.buttonColor, // Color of the border when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'Enter your username or email',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Password",
                  style: AppTextStyles.formText,
                ),
                TextField(
                  obscureText: _obscurePassword, // Hides password characters
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor, // Set the color of the border
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.buttonColor, // Color of the border when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'Enter your password',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: AppColors.primaryColor, // Custom style for the "Forgot Password" text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BtnLarge(
                      buttonText: "Sign In",
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResidentHome()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
