import 'package:flutter/material.dart';
import 'package:greenroute/common/screens/login.dart';
import 'package:greenroute/resident/screens/r_signup.dart';
import 'package:greenroute/truck_driver/screens/td_signup.dart'; // Add the TruckDriver signup screen
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../../theme.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  // Function to check user_role from SharedPreferences
  Future<String?> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role'); // Retrieve the saved user role
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "login/signup",
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 2,
              ),
              Center(
                child: Image.asset(
                  "assets/garbage_truck.png",
                  height: 84,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Center(
                child: Text(
                  "We're here to help",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 46,
              ),
              Center(
                child: BtnLarge(
                  buttonText: "Sign In",
                  onPressed: () {
                    // Navigate to the Login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 47,
              ),
              const Center(
                child: Text(
                  "or",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Retrieve user role and navigate accordingly
                    String? userRole = await _getUserRole();

                    if (userRole == 'resident') {
                      // Navigate to Resident SignUp
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RSignup(),
                        ),
                      );
                    } else if (userRole == 'truck_driver') {
                      // Navigate to Truck Driver SignUp
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TdSignup(),
                        ),
                      );
                    } else {
                      // If no role is selected, you can show an error or default behavior
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select your role first"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Create an account >>',
                    style: TextStyle(
                      color: Color(0xFF054700),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      height: 0,
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
