import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../../common/widgets/back_arrow.dart';
import '../../common/widgets/submit_cancel_buttons.dart';
import '../../common//widgets/custom_text_field.dart';
import '../../resident/widgets/custom_text_field_2.dart';
import '../utils/shared_pref_helper.dart';

class SpecialRequest extends StatefulWidget {
  const SpecialRequest({super.key});

  @override
  _SpecialRequestState createState() => _SpecialRequestState();
}

class _SpecialRequestState extends State<SpecialRequest> {
  // Controllers for the input fields
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController requestDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController plasticBagsController = TextEditingController();
  final TextEditingController paperBagsController = TextEditingController();
  final TextEditingController foodWasteBagsController = TextEditingController();
  final TextEditingController additionalNoteController =
      TextEditingController();

  // Checkboxes state
  bool _plasticSelected = false;
  bool _paperSelected = false;
  bool _foodWasteSelected = false;

  String _userEmail = ''; // To store the user's email

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    SharedPrefHelper.loadFormData(
      eventNameController: eventNameController,
      requestDateController: requestDateController,
      locationController: locationController,
      plasticBagsController: plasticBagsController,
      paperBagsController: paperBagsController,
      foodWasteBagsController: foodWasteBagsController,
      additionalNoteController: additionalNoteController,
      plasticSelected: (val) => setState(() => _plasticSelected = val),
      paperSelected: (val) => setState(() => _paperSelected = val),
      foodWasteSelected: (val) => setState(() => _foodWasteSelected = val),
    );
  }

  // Function to load email from SharedPreferences
  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _userEmail = prefs.getString('user_email') ?? 'No email found';
      },
    );
  }

  // Function to select a date with customized colors
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
              surface:
                  AppColors.backgroundSecondColor, // Calendar background color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(
        () {
          requestDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        },
      );
    }
  }

  // Function to submit the special request to Firebase
  // Function to submit the special request to Firebase
  Future<void> _submitSPform() async {
    if (requestDateController.text.isEmpty || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    // Store '0' if not selected
    String plasticBags = _plasticSelected ? plasticBagsController.text : '0';
    String paperBags = _paperSelected ? paperBagsController.text : '0';
    String foodWasteBags =
        _foodWasteSelected ? foodWasteBagsController.text : '0';

    try {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('special_requests');

      // Storing the request data in Firebase
      await dbRef.push().set(
        {
          'event_name': eventNameController.text,
          'request_date': requestDateController.text,
          'location': locationController.text,
          'plastic_selected': _plasticSelected,
          'paper_selected': _paperSelected,
          'food_waste_selected': _foodWasteSelected,
          'plastic_bags': plasticBags,
          'paper_bags': paperBags,
          'food_waste_bags': foodWasteBags,
          'additional_note': additionalNoteController.text,
          'user_email': _userEmail, // Store the user's email with the request
          'status': 'pending', // Set status as 'pending'
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully')),
      );

      // Clear form after submission
      eventNameController.clear();
      requestDateController.clear();
      locationController.clear();
      plasticBagsController.clear();
      paperBagsController.clear();
      foodWasteBagsController.clear();
      additionalNoteController.clear();
      setState(
        () {
          _plasticSelected = false;
          _paperSelected = false;
          _foodWasteSelected = false;
        },
      );

      // Clear saved form data
      await SharedPrefHelper.clearFormData();

      Navigator.pop(context); // Navigate back after successful submission
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting request: $e')),
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
                    const Text("Special Garbage Collection Request",
                        style: AppTextStyles.topic),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: eventNameController,
                        label: "Event Name (optional)",
                        hint: "Enter event name"),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                            controller: requestDateController,
                            label: "Request Date",
                            hint: "Select date"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: locationController,
                        label: "Location",
                        hint: "Enter location"),
                    const SizedBox(height: 20),
                    const Text("Garbage Type", style: AppTextStyles.formText),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: const Text("Plastic",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            value: _plasticSelected,
                            activeColor: AppColors.primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _plasticSelected = value ?? false;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Paper",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            value: _paperSelected,
                            activeColor: AppColors.primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _paperSelected = value ?? false;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Food Waste",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            value: _foodWasteSelected,
                            activeColor: AppColors.primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _foodWasteSelected = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Estimated Number of Garbage Bags",
                        style: AppTextStyles.formText),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          CustomTextField2(
                              controller: plasticBagsController,
                              label: "Plastic Bags",
                              hint: "Enter number",
                              enabled: _plasticSelected),
                          const SizedBox(height: 10),
                          CustomTextField2(
                              controller: paperBagsController,
                              label: "Paper Bags",
                              hint: "Enter number",
                              enabled: _paperSelected),
                          const SizedBox(height: 10),
                          CustomTextField2(
                              controller: foodWasteBagsController,
                              label: "Food Waste Bags",
                              hint: "Enter number",
                              enabled: _foodWasteSelected),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: additionalNoteController,
                        label: "Additional Note",
                        hint: "Enter additional note (if any)",
                        maxLines: 3),
                    const SizedBox(height: 40),
                    SubmitCancelButtons(
                      onSubmit: _submitSPform,
                      onCancel: () async {
                        await SharedPrefHelper.saveFormData(
                          eventNameController.text,
                          requestDateController.text,
                          locationController.text,
                          plasticBagsController.text,
                          paperBagsController.text,
                          foodWasteBagsController.text,
                          additionalNoteController.text,
                          _plasticSelected,
                          _paperSelected,
                          _foodWasteSelected,
                        );
                        Navigator.pop(context);
                      },
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
