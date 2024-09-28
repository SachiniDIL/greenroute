import 'package:flutter/material.dart';
import 'package:greenroute/screens/resident_home.dart';
import 'package:greenroute/widgets/button_large.dart';
import '../theme.dart';

class TdSignup extends StatefulWidget {
  const TdSignup({super.key});

  @override
  _TdSignupState createState() => _TdSignupState();
}

class _TdSignupState extends State<TdSignup> {
  bool _obscurePassword = true; // For Password field
  bool _obscureConfirmPassword = true; // For Confirm Password field

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Truck Driver Sign Up",
      home: Scaffold(
        body: Column(
          children: [
            // Fixed back arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 20.0), // Add padding for better layout
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigates back to the previous page
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Add padding for better layout
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Sign Up",
                        style: AppTextStyles.topic,
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      const Text(
                        "Full Name",
                        style: AppTextStyles.formText,
                      ),
                      TextField(
                        autofocus: true,
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
                          hintText: 'Enter your full name',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // NIC
                      const Text(
                        "NIC",
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
                          hintText: 'Enter your NIC',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Mobile Number
                      const Text(
                        "Mobile Number",
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
                          hintText: 'Enter your mobile number',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Address
                      const Text(
                        "E-mail Address",
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
                          hintText: 'Enter your email address',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Employee ID
                      const Text(
                        "Employee ID",
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
                          hintText: 'Enter your employee ID',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Truck Number
                      const Text(
                        "Truck Number",
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
                          hintText: 'Enter your truck number',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field with eye icon
                      const Text(
                        "Password",
                        style: AppTextStyles.formText,
                      ),
                      TextField(
                        obscureText: _obscurePassword, // Toggle based on the icon click
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
                      const SizedBox(height: 20),

                      // Confirm Password field with eye icon
                      const Text(
                        "Confirm Password",
                        style: AppTextStyles.formText,
                      ),
                      TextField(
                        obscureText: _obscureConfirmPassword, // Toggle based on the icon click
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
                          hintText: 'Confirm your password',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle confirm password visibility
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      Center(
                        child: BtnLarge(
                          buttonText: "Signup",
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResidentHome()),
                            );
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
      ),
    );
  }
}
