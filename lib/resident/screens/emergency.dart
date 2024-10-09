import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/resident/screens/resident_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme.dart';

class Emergency extends StatelessWidget {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Emergency({super.key});

  // Function to retrieve user_email from SharedPreferences
  Future<String?> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Function to submit form data via REST API
  Future<void> _submitEmergency(BuildContext context) async {
    final String? userEmail = await _getUserEmail();

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve user email.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String subject = subjectController.text;
    final String description = descriptionController.text;

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse(
        'https://greenroute-7251d-default-rtdb.firebaseio.com/emergencies.json'); // Updated API URL with .json
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'subject': subject,
        'description': description,
        'user_email': userEmail,
        'status': 'pending',
      }),
    );

    if (response.statusCode == 200) {
      // Firebase usually returns 200 for success
      // If the server returns a 200 response, show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency reported successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to ResidentHome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResidentHome()),
      );
    } else {
      // If the server did not return a 200 response, show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit emergency. Try again.'),
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
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Emergency",
                        style: AppTextStyles.topic,
                      ),
                      const SizedBox(height: 40),
                      // CustomTextField for Subject
                      CustomTextField(
                        controller: subjectController,
                        label: "Subject",
                        hint: "Enter the subject of the emergency",
                      ),
                      const SizedBox(height: 20),
                      // CustomTextField for Description (with multiple lines)
                      CustomTextField(
                        controller: descriptionController,
                        label: "Description",
                        hint: "Describe the emergency in detail",
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 50),
                      // Submit button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BtnLarge(
                            buttonText: 'Submit',
                            onPressed: () => _submitEmergency(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
