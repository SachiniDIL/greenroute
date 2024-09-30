import 'package:flutter/material.dart';
import 'package:greenroute/widgets/button_small.dart';
import 'package:greenroute/widgets/custom_text_field.dart';
import 'package:greenroute/utils/validators.dart';
import 'package:greenroute/services/password_reset_service.dart';
import 'package:greenroute/screens/login.dart';
import '../theme.dart';

class SetNewPwd extends StatefulWidget {
  final String userEmail;

  const SetNewPwd({super.key, required this.userEmail});

  @override
  _SetNewPwdState createState() => _SetNewPwdState();
}

class _SetNewPwdState extends State<SetNewPwd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final PasswordResetService _passwordResetService = PasswordResetService(); // Use the service

  // Method to handle password reset logic
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Call the service to update the password
        await _passwordResetService.updatePassword(widget.userEmail, _newPasswordController.text);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );

        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => Navigator.pop(context), // Navigate back
                child: const Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: AppColors.primaryColor, // Use your defined primary color
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Set New Password",
                style: AppTextStyles.topic,
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
                ),
              ),
              const SizedBox(height: 30),

              // New Password Input Field
              CustomTextField(
                controller: _newPasswordController,
                label: "New Password",
                hint: "Enter new password",
                obscureText: true,
                validator: Validators.validatePassword, // Password validation
              ),
              const SizedBox(height: 20),

              // Confirm Password Input Field
              CustomTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                hint: "Confirm new password",
                obscureText: true,
                validator: (value) => Validators.validateConfirmPassword(
                  value, _newPasswordController.text,
                ), // Confirm password validation
              ),
              const SizedBox(height: 30),

              // Reset Password Button
              Center(
                child: BtnSmall(
                  buttonText: "Reset Password",
                  onPressed: _resetPassword, // Call the reset password method
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
