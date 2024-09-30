import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenroute/screens/resident_home.dart';
import 'package:greenroute/widgets/button_large.dart';
import 'package:greenroute/widgets/custom_text_field.dart';
import 'package:greenroute/utils/validators.dart';  // Import validators
import '../theme.dart';

class RSignup extends StatefulWidget {
  const RSignup({super.key});

  @override
  _RSignupState createState() => _RSignupState();
}

class _RSignupState extends State<RSignup> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final databaseReference = FirebaseDatabase.instance.ref();  // Firebase database reference

  final fullNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final homeAddressController = TextEditingController();
  final postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Method to check if the home address already exists in the database
  Future<bool> _checkIfAddressExists(String homeAddress) async {
    final snapshot = await databaseReference
        .child('users')
        .orderByChild('homeAddress')
        .equalTo(homeAddress)
        .get();

    return snapshot.exists; // Return true if a user with the home address exists
  }

  // Method to handle sign-up process
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      // Get values from input fields
      String fullName = fullNameController.text;
      String nic = nicController.text;
      String mobile = mobileController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String homeAddress = homeAddressController.text;
      String postalCode = postalCodeController.text;

      // Check if the home address already exists
      bool addressExists = await _checkIfAddressExists(homeAddress);

      if (addressExists) {
        // If the home address already exists, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An account with this home address already exists.')),
        );
      } else {
        // Store data in Firebase Realtime Database
        await databaseReference.child("users").push().set({
          'fullName': fullName,
          'nic': nic,
          'mobile': mobile,
          'email': email,
          'password': password,
          'homeAddress': homeAddress,
          'postalCode': postalCode,
          'role': 'resident'
        });

        // Navigate to ResidentHome after successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResidentHome()),
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to previous page
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),

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
                      validator: Validators.validateMobile,  // Use validator from utils
                    ),
                    const SizedBox(height: 20),

                    // Email Address Field
                    CustomTextField(
                      controller: emailController,
                      label: "Email Address",
                      hint: "Enter your email address",
                      validator: Validators.validateEmail,  // Use validator from utils
                    ),
                    const SizedBox(height: 20),

                    // Home Address Field
                    CustomTextField(
                      controller: homeAddressController,
                      label: "Home Address",
                      hint: "Enter your home address",
                      validator: (value) => value!.isEmpty ? 'Home Address is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Postal Code Field
                    CustomTextField(
                      controller: postalCodeController,
                      label: "Postal Code",
                      hint: "Enter your postal code",
                      validator: Validators.validatePostalCode,  // Use validator from utils
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
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: Validators.validatePassword,  // Use validator from utils
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
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
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
