import 'package:flutter/material.dart';
import 'package:greenroute/screens/resident_home.dart';
import 'package:greenroute/widgets/button_large.dart';
import '../theme.dart';

class RSignup extends StatefulWidget {
  const RSignup({super.key});

  @override
  _RSignupState createState() => _RSignupState();
}

class _RSignupState extends State<RSignup> {
  bool _obscurePassword = true; // For Password field
  bool _obscureConfirmPassword = true; // For Confirm Password field

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Resident Sign Up",
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
                      const Text(
                        "Home Address",
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
                          hintText: 'Enter your home address',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Postal Code",
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
                          hintText: 'Enter your postal code',
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
                      const SizedBox(height: 20),
                      const Text(
                        "Confirm Password",
                        style: AppTextStyles.formText,
                      ),
                      TextField(
                        obscureText: _obscureConfirmPassword, // Hides password characters
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
                          buttonText: "Sign Up",
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
