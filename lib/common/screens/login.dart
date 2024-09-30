import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/services/login_service.dart';
import '../widgets/back_arrow.dart';
import 'forgot_password.dart'; // Import Forgot Password Page
import '../../resident/screens/resident_home.dart'; // Import Resident Home Page
import '../../theme.dart'; // Import custom theme
import '../widgets/button_large.dart'; // Import custom button
import '../widgets/custom_text_field.dart'; // Import custom text field
import '../../common/utils/validators.dart'; // Import validators

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true; // Password visibility toggle

  // Controllers for TextFields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final LoginService _loginService =
      LoginService(); // Instantiate the login service

  Future<String?> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role'); // Retrieve the saved user role
  }

  // Function to save login state and email to SharedPreferences
  Future<void> _saveLoginState(
      bool isLoggedIn, String userRole, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn); // Save login state
    await prefs.setString('user_role', userRole); // Save user role
    await prefs.setString('user_email', email); // Save user's email
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String? userRole = await _getUserRole();
      if (userRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your role first")),
        );
        return;
      }

      // Use LoginService to validate the credentials
      bool isValidUser = await _loginService.validateUser(
        emailController.text,
        passwordController.text,
      );

      if (isValidUser) {
        // Save login status and email to SharedPreferences
        await _saveLoginState(true, userRole,
            emailController.text); // Save the login state and email

        if (userRole == 'resident') {
          // Navigate to Resident Home
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResidentHome()),
          );
        } else if (userRole == 'truck_driver') {
          // Navigate to Truck Driver Home (change to appropriate page)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ResidentHome()), // Change this to Truck Driver Home
          );
        }
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed Back Arrow (Non-scrollable)
          BackArrow(),

          // Scrollable Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Sign In", style: AppTextStyles.topic),
                    const SizedBox(height: 40),

                    // Username or Email Field
                    CustomTextField(
                      controller: emailController,
                      label: "Username or Email",
                      hint: "Enter your username or email",
                      validator:
                          Validators.validateEmail, // Use email validator
                    ),
                    const SizedBox(height: 20),

                    // Password Field with Eye Icon
                    CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixTap: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword; // Toggle password visibility
                        });
                      },
                      validator:
                          Validators.validatePassword, // Use password validator
                    ),
                    const SizedBox(height: 10),

                    // Forgot Password Link
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          // Custom style for the "Forgot Password" text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In Button
                    Center(
                      child: BtnLarge(
                        buttonText: "Sign In",
                        onPressed: () async {
                          await _login();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
