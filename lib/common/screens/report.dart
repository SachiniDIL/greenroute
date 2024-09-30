import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Database
import 'package:shared_preferences/shared_preferences.dart'; // Shared Preferences
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/common/widgets/submit_cancel_buttons.dart';
import '../../theme.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Controllers for the input fields
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('reports'); // Reference to Firebase
  String _userEmail = ''; // Variable to store the user's email

  @override
  void initState() {
    super.initState();
    _loadEmailFromPreferences(); // Load the user's email when the screen initializes
  }

  // Method to load email from SharedPreferences
  Future<void> _loadEmailFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ??
          'No email found'; // Get email from SharedPreferences
    });
  }

  // Method to submit the report
  Future<void> _submitReport() async {
    if (subjectController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    try {
      // Storing report details in Firebase Database
      await _dbRef.push().set({
        'email': _userEmail, // Store the user's email
        'subject': subjectController.text,
        'description': descriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );

      // Clear the form
      subjectController.clear();
      descriptionController.clear();

      // Navigate back after submitting
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed Back Arrow (Non-scrollable)
          const BackArrow(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Report", style: AppTextStyles.topic),
                    const SizedBox(height: 20),

                    // Subject Input Field
                    CustomTextField(
                      controller: subjectController,
                      label: "Subject",
                      hint: "Enter the subject",
                    ),
                    const SizedBox(height: 20),

                    // Description Input Field (Multiline)
                    CustomTextField(
                      controller: descriptionController,
                      label: "Description",
                      hint: "Enter the description",
                      maxLines: 5, // Allows multiple lines for the description
                    ),
                    const SizedBox(height: 30),

                    // Submit and Cancel Buttons
                    const SizedBox(height: 40),
                    SubmitCancelButtons(
                      onSubmit: _submitReport, // Call the submit function
                    ),
                    const SizedBox(height: 30),
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
