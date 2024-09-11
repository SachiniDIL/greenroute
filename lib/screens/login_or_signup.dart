import 'package:flutter/material.dart';
import 'package:greenroute/screens/resident_home.dart';
import 'package:greenroute/widgets/button_large.dart';

import '../theme.dart';

class LoginSignup extends StatelessWidget{
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "login/signup",
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 148,
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
                child: Text("We're here to help",
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
                child: BtnLarge(buttonText: "Sign In",
                  onPressed: () {
                    // Navigate to the NextPage when Skip is pressed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const ResidentHome()), // Replace with desired page
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 47,
              ),
              const Center(
                child: Text("or",
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
              const Center(
                child: Text(
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
              const SizedBox(
                height: 270,
              ),
            ],
          ),
        ),
      ),
    );
  }

}