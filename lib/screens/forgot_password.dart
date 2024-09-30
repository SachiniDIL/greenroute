import 'package:flutter/material.dart';
import 'package:greenroute/widgets/back_arrow.dart';
import 'package:greenroute/widgets/button_small.dart';
import 'package:greenroute/widgets/custom_text_field.dart'; // Reusable custom text field
import 'package:greenroute/utils/validators.dart'; // Import validators
import 'package:greenroute/services/forgot_password_service.dart'; // Import the service
import 'check_mail.dart'; // Import the CheckMail page
import '../theme.dart'; // Assuming you have a theme file for AppColors and AppTextStyles

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService(); // Instantiate the service

  // Method to handle the reset password request
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;

      // Check if the email exists in the Firebase database
      bool emailExists = await _forgotPasswordService.checkEmailExists(email);

      if (emailExists) {
        // Navigate to the CheckMail page and pass the email
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckMail(userEmail: email)),
        );
      } else {
        // Show an error message if the email does not exist in the database
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("The email entered does not exist in our records.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Adjust spacing for better UI alignment
                BackArrow(),
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

                // Email Input Field using CustomTextField
                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Enter your email",
                  validator: Validators.validateEmail, // Use the email validator from validators.dart
                ),

                const SizedBox(height: 30),

                // Reset Password Button
                Center(
                  child: BtnSmall(
                    buttonText: "Reset Password",
                    onPressed: () {
                      _resetPassword();  // Call the reset password method
                    },
                  ),
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
