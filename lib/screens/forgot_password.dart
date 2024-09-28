import 'package:flutter/material.dart';
import 'package:greenroute/widgets/button_large.dart';
import '../theme.dart'; // Assuming you have a theme file where AppColors and AppTextStyles are defined
import '../widgets/button_small.dart';
import 'check_mail.dart'; // Import the CheckMail page

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController();

  // Function to validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Simple email regex validation
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Forgot Password",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Assign the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Adjust spacing for better UI alignment
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigates back to the previous page
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: AppColors.primaryColor, // Use your defined primary color
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Forgot Password",
                    style: AppTextStyles.topic, // Custom text style from your theme
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Please enter your email to reset the password.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0.09,
                      letterSpacing: -0.50,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Email",
                    style: AppTextStyles.formText, // Same formText styling
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                      hintText: 'Enter your email',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    ),
                    validator: _validateEmail, // Add email validation
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: BtnSmall(
                      buttonText: "Reset Password",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform reset password logic
                          print('Valid email: ${_emailController.text}');

                          // Navigate to CheckMail page after validation
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckMail()),
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
