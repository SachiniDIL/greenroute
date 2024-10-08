import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/services/login_service.dart';
import '../../disposal_officer/screens/do_home.dart';
import '../widgets/back_arrow.dart';
import 'forgot_password.dart'; // Import Forgot Password Page
import '../../resident/screens/resident_home.dart'; // Resident Home
import '../../truck_driver/screens/truck_driver_home.dart'; // Truck Driver Home
import '../../theme.dart'; // Custom theme
import '../widgets/button_large.dart'; // Custom button
import '../widgets/custom_text_field.dart'; // Custom text field
import '../../common/utils/validators.dart'; // Validators

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true; // Password visibility toggle
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final LoginService _loginService = LoginService(); // Login service

  Future<String?> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role'); // Retrieve user role
  }

  // Save login state and email
  Future<void> _saveLoginState(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', true); // Save login state as true
    await prefs.setString('user_email', email); // Save the user's email
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

      // Use LoginService to validate the credentials and retrieve the email
      String? userEmail = await _loginService.validateUser(
        emailController.text,
        passwordController.text,
      );

      if (userEmail != null) {
        // Save login state and the user's email
        await _saveLoginState(userEmail);

        // Show success SnackBar with green background
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the correct home screen based on user role
        if (userRole == 'resident') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResidentHome()),
          );
        } else if (userRole == 'truck_driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TruckDriverHome()),
          );
        } else if (userRole == 'disposal_officer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DOHome()),
          );
        }
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username/email or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackArrow(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Sign In", style: AppTextStyles.topic),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: emailController,
                      label: "Username or Email",
                      hint: "Enter your username or email",
                      validator: (value) => Validators.validateEmailOrUsername(value),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      onSuffixTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; // Toggle password visibility
                        });
                      },
                      validator: Validators.validatePassword,
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
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
