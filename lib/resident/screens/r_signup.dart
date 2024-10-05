import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/resident/screens/resident_home.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/common/utils/validators.dart';
import '../../theme.dart';
import '../../common/widgets/back_arrow.dart';

class RSignup extends StatefulWidget {
  const RSignup({super.key});

  @override
  _RSignupState createState() => _RSignupState();
}

class _RSignupState extends State<RSignup> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final fullNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final homeAddressController = TextEditingController();
  final postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // URL for your API endpoint
  final String apiUrl = "https://greenroute-7251d-default-rtdb.firebaseio.com"; // Replace with your actual API URL

  // Method to send data to REST API
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      print('Form validated successfully');

      // Get values from input fields
      String fullName = fullNameController.text;
      String nic = nicController.text;
      String mobile = mobileController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String homeAddress = homeAddressController.text;
      String postalCode = postalCodeController.text;

      // Prepare the request payload
      Map<String, String> userData = {
        'fullName': fullName,
        'nic': nic,
        'mobile': mobile,
        'email': email,
        'password': password,
        'homeAddress': homeAddress,
        'postalCode': postalCode,
        'role': 'resident'
      };

      try {
        // Send POST request to the API
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(userData),
        );

        if (response.statusCode == 201) {
          print('User created successfully');
          // Navigate to ResidentHome after successful sign-up
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResidentHome()),
          );
        } else {
          print('Failed to create user: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create user: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error during sign-up: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      print('Form validation failed');
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
                    const Text("Sign Up", style: AppTextStyles.topic),
                    const SizedBox(height: 20),

                    // Full Name Field
                    CustomTextField(
                      controller: fullNameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      validator: (value) =>
                      value!.isEmpty ? 'Full Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // NIC Field
                    CustomTextField(
                      controller: nicController,
                      label: "NIC",
                      hint: "Enter your NIC",
                      validator: (value) =>
                      value!.isEmpty ? 'NIC is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Mobile Number Field
                    CustomTextField(
                      controller: mobileController,
                      label: "Mobile Number",
                      hint: "Enter your mobile number",
                      validator: Validators.validateMobile,
                    ),
                    const SizedBox(height: 20),

                    // Email Address Field
                    CustomTextField(
                      controller: emailController,
                      label: "Email Address",
                      hint: "Enter your email address",
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Home Address Field
                    CustomTextField(
                      controller: homeAddressController,
                      label: "Home Address",
                      hint: "Enter your home address",
                      validator: (value) =>
                      value!.isEmpty ? 'Home Address is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Postal Code Field
                    CustomTextField(
                      controller: postalCodeController,
                      label: "Postal Code",
                      hint: "Enter your postal code",
                      validator: Validators.validatePostalCode,
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
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field with Eye Icon
                    CustomTextField(
                      controller: passwordController,
                      label: "Confirm Password",
                      hint: "Confirm your password",
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) => Validators.validateConfirmPassword(
                          value, passwordController.text),
                    ),
                    const SizedBox(height: 50),

                    // Sign Up Button
                    Center(
                      child: BtnLarge(
                        buttonText: "Sign Up",
                        onPressed: _handleSignUp,
                      ),
                    ),
                    const SizedBox(height: 60),
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
