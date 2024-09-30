import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';

import '../../common/utils/validators.dart';
import '../../theme.dart'; // Custom Text Field Widget

class TdSignup extends StatefulWidget {
  const TdSignup({super.key});

  @override
  _TdSignupState createState() => _TdSignupState();
}

class _TdSignupState extends State<TdSignup> {
  bool _obscurePassword = true; // For Password field visibility
  bool _obscureConfirmPassword = true; // For Confirm Password field visibility

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  // Firebase Database reference
  final databaseReference = FirebaseDatabase.instance.ref();

  // TextEditingController for input fields
  final fullNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final employeeIdController = TextEditingController();
  final truckNumberController = TextEditingController();
  final passwordController = TextEditingController();

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
                    const Text("Sign Up", style: AppTextStyles.topic),
                    const SizedBox(height: 20),

                    // Full Name Field
                    CustomTextField(
                      controller: fullNameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      validator: (value) => value!.isEmpty ? 'Full Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // NIC Field
                    CustomTextField(
                      controller: nicController,
                      label: "NIC",
                      hint: "Enter your NIC",
                      validator: (value) => value!.isEmpty ? 'NIC is required' : null,
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

                    // Employee ID Field
                    CustomTextField(
                      controller: employeeIdController,
                      label: "Employee ID",
                      hint: "Enter your employee ID",
                      validator: (value) => value!.isEmpty ? 'Employee ID is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Truck Number Field
                    CustomTextField(
                      controller: truckNumberController,
                      label: "Truck Number",
                      hint: "Enter your truck number",
                      validator: (value) => value!.isEmpty ? 'Truck Number is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Password Field with Eye Icon
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
                    const SizedBox(height: 20),

                    // Confirm Password Field with Eye Icon
                    CustomTextField(
                      controller: passwordController,
                      label: "Confirm Password",
                      hint: "Confirm your password",
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      onSuffixTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle confirm password visibility
                        });
                      },
                      validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
                    ),
                    const SizedBox(height: 50),

                    // Sign Up Button
                    Center(
                      child: BtnLarge(
                        buttonText: "Sign Up",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Store data in Firebase Realtime Database
                            await databaseReference.child("truck_drivers").push().set({
                              'fullName': fullNameController.text,
                              'nic': nicController.text,
                              'mobile': mobileController.text,
                              'email': emailController.text,
                              'employeeId': employeeIdController.text,
                              'truckNumber': truckNumberController.text,
                              'password': passwordController.text,
                              'role': 'truck_driver'
                            });

                            // Navigate to ResidentHome after successful sign-up
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TruckDriverHome()),
                            );
                          }
                        },
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
