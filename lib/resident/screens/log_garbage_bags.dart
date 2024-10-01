import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../theme.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';

import '../services/log_bags_service.dart';
import '../widgets/bag_row.dart';

class LogGarbage extends StatefulWidget {
  const LogGarbage({super.key});

  @override
  _LogGarbageState createState() => _LogGarbageState();
}

class _LogGarbageState extends State<LogGarbage> {
  int plasticBags = 0;
  int paperBags = 0;
  int foodBags = 0;
  int totalBags = 0;
  String _userEmail = '';
  DatabaseReference? _logRef; // Firebase log reference

  // Controllers for form fields
  TextEditingController plasticController = TextEditingController();
  TextEditingController paperController = TextEditingController();
  TextEditingController foodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  // Load user's email and existing log from Firebase
  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'No email found';
    });
    await LogBagsService.loadExistingLog(
      userEmail: _userEmail,
      onLogFound: _onLogFound,
    );
  }

  // Callback for when log data is found
  void _onLogFound(Map<String, dynamic> logData, DatabaseReference logRef) {
    setState(() {
      plasticBags = logData['plastic_bags'] ?? 0;
      paperBags = logData['paper_bags'] ?? 0;
      foodBags = logData['food_bags'] ?? 0;
      totalBags = logData['total_bags'] ?? 0;
      _logRef = logRef;  // Save the reference for future updates

      // Populate input fields with data
      plasticController.text = plasticBags.toString();
      paperController.text = paperBags.toString();
      foodController.text = foodBags.toString();
    });
  }

  // Update the total number of bags
  void _updateTotalBags() {
    setState(() {
      totalBags = plasticBags + paperBags + foodBags;
    });
  }

  // Handle the changes in bag count
  void _updateBags(String type, int newValue) {
    setState(() {
      if (type == 'plastic') {
        plasticBags = newValue;
        plasticController.text = plasticBags.toString();
      } else if (type == 'paper') {
        paperBags = newValue;
        paperController.text = paperBags.toString();
      } else if (type == 'food') {
        foodBags = newValue;
        foodController.text = foodBags.toString();
      }
      _updateTotalBags();

      if (_logRef != null) {
        // Ensure logRef exists before updating
        LogBagsService.updateLog(
          logRef: _logRef!,
          plasticBags: plasticBags,
          paperBags: paperBags,
          foodBags: foodBags,
          totalBags: totalBags,
          userEmail: _userEmail,
        );
      }
    });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Log Garbage Bags", style: AppTextStyles.topic),
                  const SizedBox(height: 20),
                  const Text(
                    'Log your garbage bags and keep the collection smooth and efficient!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 90.0),

                  // Bag Rows for Plastic, Paper, and Food
                  BagRow(
                    label: 'Plastic',
                    controller: plasticController,
                    bagCount: plasticBags,
                    onCountChanged: (newValue) =>
                        _updateBags('plastic', newValue),
                  ),
                  const SizedBox(height: 10.0),
                  BagRow(
                    label: 'Paper',
                    controller: paperController,
                    bagCount: paperBags,
                    onCountChanged: (newValue) =>
                        _updateBags('paper', newValue),
                  ),
                  const SizedBox(height: 10.0),
                  BagRow(
                    label: 'Food',
                    controller: foodController,
                    bagCount: foodBags,
                    onCountChanged: (newValue) =>
                        _updateBags('food', newValue),
                  ),
                  const SizedBox(height: 20.0),

                  // Total Bags Row
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Bags',
                          style: TextStyle(
                            color: Color(0xFF054700),
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          width: 60,
                          height: 41,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFF054700),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            totalBags.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
