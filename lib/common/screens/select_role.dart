import 'package:flutter/material.dart';
import 'package:greenroute/resident/screens/r_onboarding1.dart';
import 'package:greenroute/truck_driver/screens/td_onboarding1.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/common/widgets/button_small.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../truck_driver/screens/truck_driver_home.dart';
import 'login_or_signup.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  // Function to save the selected role to SharedPreferences
  Future<void> _saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  // Function to check if the user has completed the onboarding process
  Future<bool> _checkOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Add some padding on the sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Logo or image at the top
              Flexible(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    "assets/garbage_truck.png",
                    height:
                        screenHeight * 0.12, // Adjust based on screen height
                  ),
                ),
              ),

              // Title text
              const Flexible(
                flex: 2,
                child: Center(
                  child: Text(
                    'Select Your Role',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 28,
                      // Reduce font size to fit on smaller screens
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Buttons for selecting role
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: BtnSmall(
                        buttonText: "Resident",
                        onPressed: () async {
                          await _saveRole('resident');
                          bool onboardingComplete =
                              await _checkOnboardingComplete();

                          if (onboardingComplete) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginSignup()));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ROnboarding1()),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Expanded(
                      child: BtnSmall(
                        buttonText: "Truck Driver",
                        onPressed: () async {
                          await _saveRole('truck_driver');
                          bool onboardingComplete =
                              await _checkOnboardingComplete();

                          if (onboardingComplete) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TruckDriverHome()));// TODO
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TdOnboarding1()),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Expanded(
                      child: BtnSmall(
                        buttonText: "Disposal Officer",
                        onPressed: () async {
                          await _saveRole('disposal_officer');
                          bool onboardingComplete =
                              await _checkOnboardingComplete();

                          if (onboardingComplete) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginSignup()));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TdOnboarding1()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
