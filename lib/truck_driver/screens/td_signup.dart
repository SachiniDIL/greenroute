import 'package:flutter/material.dart';
import 'package:greenroute/common/screens/login_or_signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import '../../common/utils/validators.dart';
import '../../theme.dart';

class TdSignup extends StatefulWidget {
  const TdSignup({super.key});

  @override
  _TdSignupState createState() => _TdSignupState();
}

class _TdSignupState extends State<TdSignup> {
  bool _obscurePassword = true; // For Password field visibility
  bool _obscureConfirmPassword = true; // For Confirm Password field visibility

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  // TextEditingController for input fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // New controller for Confirm Password

  String? selectedMunicipalCouncil;
  String? selectedEmployeeId;
  List<Map<String, String>> municipalCouncilList = [];
  List<Map<String, String>> employeeIdList = [];

  // Firebase REST API URL
  final String apiUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com';

  @override
  void initState() {
    super.initState();
    _fetchMunicipalCouncils(); // Fetch municipal councils on initialization
  }

  // Fetch municipal councils
  Future<void> _fetchMunicipalCouncils() async {
    try {
      final response =
      await http.get(Uri.parse('$apiUrl/municipal_council.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          // Fetching the actual 'council_id' field from the record, not the key
          municipalCouncilList = data.entries.map((entry) {
            return {
              'council_id': entry.value['council_id'].toString(),
              // Correct field
              'council_name': entry.value['council_name'].toString(),
            };
          }).toList();
        });
        print(
            'Municipal Councils fetched: $municipalCouncilList'); // Debug output
      } else {
        print(
            'Error fetching municipal councils: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching municipal councils: $e');
    }
  }

  // Fetch employee IDs based on selected municipal council
  Future<void> _fetchEmployeeIds(String councilId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/truck_driver.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          // Filter truck_driver where signup == false and municipal_council_id matches
          employeeIdList = data.entries.where((entry) {
            return entry.value['signup'] == false &&
                entry.value['municipal_council_id'].toString() == councilId;
          }).map((entry) {
            return {
              'emp_id': entry.value['emp_id'].toString(),
              'truck_driver_key': entry.key.toString(),
            };
          }).toList();
        });
        print(
            'Employee IDs for selected council: $employeeIdList'); // Debug output

        if (employeeIdList.isEmpty) {
          print('No employees available for this council'); // Debug output
        }
      } else {
        print('Error fetching employee IDs: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employee IDs: $e');
    }
  }

  // Update truck driver data
  Future<void> _updateTruckDriver(String truckDriverKey) async {
    final driverData = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'username': usernameController.text,
      'password': passwordController.text,
      'signup': true,
    };

    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/truck_driver/$truckDriverKey.json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(driverData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup successful!"),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to Truck Driver Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginSignup()),
        );
      } else {
        throw Exception('Failed to update data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
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

                    // First Name
                    CustomTextField(
                      controller: firstNameController,
                      label: "First Name",
                      hint: "Enter your first name",
                      validator: (value) =>
                      value!.isEmpty ? 'First Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Last Name
                    CustomTextField(
                      controller: lastNameController,
                      label: "Last Name",
                      hint: "Enter your last name",
                      validator: (value) =>
                      value!.isEmpty ? 'Last Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Municipal Council Dropdown
                    const Text("Municipal Council",
                        style: AppTextStyles.formText),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedMunicipalCouncil,
                      hint: const Text("Select Municipal Council"),
                      items: municipalCouncilList.map((council) {
                        return DropdownMenuItem(
                          value: council['council_id'], // Correct council_id
                          child: Text(council['council_name']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMunicipalCouncil = value;
                          selectedEmployeeId = null;
                          employeeIdList.clear(); // Clear employee ID dropdown
                        });
                        if (value != null) {
                          _fetchEmployeeIds(
                              value); // Fetch employee IDs based on selected council
                        }
                      },
                      validator: (value) => value == null
                          ? 'Please select a Municipal Council'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Employee ID Dropdown
                    const Text("Employee ID", style: AppTextStyles.formText),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedEmployeeId,
                      hint: const Text("Select Employee ID"),
                      items: employeeIdList.map(
                            (emp) {
                          return DropdownMenuItem(
                            value: emp['truck_driver_key'],
                            child: Text(emp['emp_id']!), // Display emp_id
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEmployeeId = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select an Employee ID' : null,
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

                    // Email Field
                    CustomTextField(
                      controller: emailController,
                      label: "Email Address",
                      hint: "Enter your email address",
                      validator: Validators.validateEmail,
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

                    // Password Field
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

                    // Confirm Password Field
                    CustomTextField(
                      controller: confirmPasswordController, // Use the confirmPasswordController
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              selectedEmployeeId != null) {
                            await _updateTruckDriver(selectedEmployeeId!);
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
