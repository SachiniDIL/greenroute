import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/common/utils/validators.dart';
import '../../theme.dart';
import '../../common/widgets/back_arrow.dart';
import 'do_home.dart'; // The screen to navigate after successful signup

class DOSignup extends StatefulWidget {
  const DOSignup({super.key});

  @override
  _DOSignupState createState() => _DOSignupState();
}

class _DOSignupState extends State<DOSignup> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> disposalOfficerList = [];
  String? selectedDisposalOfficerId;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Fetch the list of disposal officers where signup is false
  // Fetch the list of disposal officers where signup is false
  Future<void> _fetchDisposalOfficers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
            "https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer.json"),
      );
      if (response.statusCode == 200) {
        dynamic decodedData = json.decode(response.body);
        print('Fetched data: $decodedData');
        if (decodedData is Map) {
          disposalOfficerList = decodedData.entries
              .where((entry) => entry.value['signup'] == false)
              .map((entry) {
            return {
              'disposal_officer_id': entry.value['disposal_officer_id'],
              ...Map<String, dynamic>.from(entry.value),
            };
          }).toList();
          print('Disposal Officer List: $disposalOfficerList');
        }

        if (mounted) {
          setState(() {});  // This ensures the UI updates with the new data
        }
      } else {
        throw Exception('Failed to load disposal officers');
      }
    } catch (e) {
      print('Error fetching disposal officers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Future<String?> getDisposalOfficerKey(String disposalOfficerId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer.json"),
      );

      if (response.statusCode == 200) {
        dynamic decodedData = json.decode(response.body);

        if (decodedData is Map) {
          for (var entry in decodedData.entries) {
            var officer = entry.value;
            if (officer['disposal_officer_id'] == disposalOfficerId) {
              return entry.key;
            }
          }
        }
      } else {
        throw Exception('Failed to load disposal officers');
      }
    } catch (e) {
      print('Error fetching officer key: $e');
    }

    return null;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      print('Form validated successfully');

      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String email = emailController.text;
      String mobile = mobileController.text;
      String nic = nicController.text;
      String username = usernameController.text;
      String password = passwordController.text;

      if (selectedDisposalOfficerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an Employee ID."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      var officer = disposalOfficerList.firstWhere(
            (officer) => officer['disposal_officer_id'] == selectedDisposalOfficerId,
        orElse: () => {},
      );

      if (officer.isNotEmpty &&
          officer['email'] == email &&
          officer['phone_number'] == mobile) {
        if (officer['nic'] == nic) {
          try {
            Map<String, dynamic> updatedOfficerData = {
              'first_name': firstName,
              'last_name': lastName,
              'username': username,
              'password': password,
              'signup': true
            };

            String? officerKey = await getDisposalOfficerKey(officer['disposal_officer_id']);

            if (officerKey == null) {
              print('No matching officer found');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to find disposal officer key')),
              );
              return;
            }

            print('Request data: $updatedOfficerData');
            var response = await http.patch(
              Uri.parse(
                  "https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer/$officerKey.json"),
              headers: {"Content-Type": "application/json"},
              body: json.encode(updatedOfficerData),
            );

            if (response.statusCode == 200) {
              print('User signed up successfully');
              _fetchDisposalOfficers();

              // Show success SnackBar with green background
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signup successful!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,  // Optional: Make it floating
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DOHome()),
              );
            } else {
              print('Failed to update user: ${response.body}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign up: ${response.body}')),
              );
            }
          } catch (e) {
            print('Error during sign-up: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("NIC doesn't match the records."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email or mobile number doesn't match the records."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('Form validation failed');
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchDisposalOfficers();
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Employee ID",
                            style: AppTextStyles.formText),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
                          ),
                          value: selectedDisposalOfficerId,
                          items: disposalOfficerList.map((officer) {
                            return DropdownMenuItem<String>(
                              value: officer['disposal_officer_id'],
                              child: Text(officer['disposal_officer_id']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDisposalOfficerId = value;
                            });
                            print('Selected Officer ID: $selectedDisposalOfficerId');
                          },
                          validator: (value) =>
                          value == null ? 'Please select an Employee ID' : null,
                        ),

                      ],
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: firstNameController,
                      label: "First Name",
                      hint: "Enter your first name",
                      validator: (value) =>
                      value!.isEmpty ? 'First Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: lastNameController,
                      label: "Last Name",
                      hint: "Enter your last name",
                      validator: (value) =>
                      value!.isEmpty ? 'Last Name is required' : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: nicController,
                      label: "NIC",
                      hint: "Enter your NIC",
                      validator: (value) =>
                      value!.isEmpty ? 'NIC is required' : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: mobileController,
                      label: "Mobile Number",
                      hint: "+94",
                      validator: Validators.validateMobile,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: emailController,
                      label: "Email",
                      hint: "Enter your email",
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: usernameController,
                      label: "Username",
                      hint: "Enter your username",
                      validator: (value) =>
                      value!.isEmpty ? 'Username is required' : null,
                    ),
                    const SizedBox(height: 20),

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

                    CustomTextField(
                      controller: confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Confirm your password",
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixTap: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) =>
                          Validators.validateConfirmPassword(
                              value, passwordController.text),
                    ),
                    const SizedBox(height: 50),

                    Center(
                      child: BtnLarge(
                        buttonText: "Sign Up",
                        onPressed: _handleSignup,
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
