import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:greenroute/common/screens/login_or_signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/common/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // NEW controller for confirm password
  final homeAddressController = TextEditingController();
  final postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // URL for your API endpoint
  final String apiUrl =
      "https://greenroute-7251d-default-rtdb.firebaseio.com/resident.json"; // Replace with your actual Firebase API URL

  // Method to check if the email or username already exists
  Future<bool> _checkEmailOrUsernameExists(String email, String username) async {
    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> residents = json.decode(response.body);
        for (var resident in residents.values) {
          if (resident['email'] == email || resident['username'] == username) {
            return true; // Email or username already exists
          }
        }
      }
    } catch (e) {
      print('Error checking email or username: $e');
    }
    return false;
  }

  // Method to get the next available resident_id
  Future<String> _getNextResidentId() async {
    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> residents = json.decode(response.body);
        List<String> ids = residents.keys
            .map((key) => residents[key]['res_id'] as String)
            .toList();

        if (ids.isNotEmpty) {
          ids.sort(); // Sort the IDs to find the latest one
          String lastId = ids.last; // Get the last ID, e.g., "RES003"
          int nextIdNumber = int.parse(lastId.substring(3)) + 1;
          return "RES${nextIdNumber.toString().padLeft(3, '0')}"; // Generate next ID, e.g., "RES004"
        }
      }
    } catch (e) {
      print('Error fetching resident IDs: $e');
    }
    return "RES001"; // If no resident IDs exist, return "RES001"
  }

  // Method to store FCM token in SharedPreferences
  Future<void> _saveFcmTokenToSharedPreferences(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmToken', fcmToken);
    print("FCM Token saved in SharedPreferences: $fcmToken");
  }

  // Method to show a SnackBar
  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Method to send data to Firebase
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      print('Form validated successfully');

      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String username = usernameController.text;
      String nic = nicController.text;
      String mobile = mobileController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String homeAddress = homeAddressController.text;
      String postalCode = postalCodeController.text;

      // Check if the email or username already exists
      bool exists = await _checkEmailOrUsernameExists(email, username);
      if (exists) {
        _showSnackBar(context, "Email or Username already exists", Colors.red);
        return;
      }

      // Get the next unique resident ID
      String residentId = await _getNextResidentId();

      // Fetch FCM token
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();

      if (fcmToken == null) {
        _showSnackBar(context, "Failed to get FCM token", Colors.red);
        return;
      }

      // Save the FCM token in SharedPreferences
      await _saveFcmTokenToSharedPreferences(fcmToken);

      // Prepare the request payload
      Map<String, String> userData = {
        'res_id': residentId,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'nic': nic,
        'phone_number': mobile,
        'email': email,
        'password': password,
        'home_address': homeAddress,
        'postal_code': postalCode,
        'role': 'Resident', // Save role as 'Resident'
        'fcmToken': fcmToken // Add FCM token to the data
      };

      try {
        // Send POST request to the Firebase database
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          _showSnackBar(context, "Sign Up Successful!", Colors.green);
          // Navigate to LoginSignup after successful sign-up
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginSignup()),
          );
        } else {
          _showSnackBar(context, 'Failed to create user: ${response.body}', Colors.red);
        }
      } catch (e) {
        _showSnackBar(context, 'Error: $e', Colors.red);
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

                    // First Name Field
                    CustomTextField(
                      controller: firstNameController,
                      label: "First Name",
                      hint: "Enter your first name",
                      validator: (value) =>
                      value!.isEmpty ? 'First Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Last Name Field
                    CustomTextField(
                      controller: lastNameController,
                      label: "Last Name",
                      hint: "Enter your last name",
                      validator: (value) =>
                      value!.isEmpty ? 'Last Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    CustomTextField(
                      controller: usernameController,
                      label: "Username",
                      hint: "Enter your username",
                      validator: (value) =>
                      value!.isEmpty ? 'Username is required' : null,
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
                      controller: confirmPasswordController, // Use separate controller for confirm password
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
