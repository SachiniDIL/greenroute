import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenroute/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/back_arrow.dart';
import '../widgets/star_rating.dart';
import '../widgets/submit_cancel_buttons.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('feedback');

  int _rating = 0;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _loadEmailFromPreferences();
  }

  Future<void> _loadEmailFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'No email found';
    });
  }

  Future<void> _submitFeedback() async {
    if (nameController.text.isEmpty ||
        subjectController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields and rate us')),
      );
      return;
    }

    try {
      await _dbRef.push().set({
        'name': nameController.text,
        'email': _userEmail,
        'subject': subjectController.text,
        'description': descriptionController.text,
        'rating': _rating,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );

      // Clear the form
      nameController.clear();
      subjectController.clear();
      descriptionController.clear();
      setState(() {
        _rating = 0;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BackArrow(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Feedback", style: AppTextStyles.topic),
                    const SizedBox(height: 20),
                    const Text(
                      'We Care About You!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Input Fields
                    CustomTextField(
                        controller: nameController,
                        label: "Name",
                        hint: "Enter your name"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: subjectController,
                        label: "Subject",
                        hint: "Enter subject"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: descriptionController,
                        label: "Description",
                        hint: "Enter description",
                        maxLines: 5),
                    const SizedBox(height: 30),

                    const Text("Rate Us",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    StarRating(
                        rating: _rating,
                        onRatingChanged: (newRating) =>
                            setState(() => _rating = newRating)),

                    const SizedBox(height: 40),
                    SubmitCancelButtons(onSubmit: _submitFeedback),
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
