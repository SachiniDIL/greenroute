import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/new_button.dart';
import 'package:greenroute/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import to close the app
import '../../common/widgets/home_header.dart';
import '../widgets/bottom_nav_resident.dart';
import 'emergency.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({super.key});

  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  String? userRole;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      userEmail = prefs.getString('user_email');
      isLoading = false;
    });
  }

  Future<void> _showExitConfirmationDialog() async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // Exit the app
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
    }

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          // Show exit confirmation dialog when the user presses back
          await _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondColor,
        body: Column(
          children: [
            SizedBox(
              child: HomeHeader(
                userRole: userRole ?? "Guest",
                userEmail: userEmail ?? "Not Available",
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 7.0),
                      Container(
                        height: 52.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Track your truck',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Report an emergency',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              SizedBox(height: 20),
                              BtnNew(
                                width: 132,
                                height: 30,
                                buttonText: 'Report!',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Emergency(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Image.asset(
                          'assets/resident_home.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavR(current: 'home'),
          ],
        ),
      ),
    );
  }
}
