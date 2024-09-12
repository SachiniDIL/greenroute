import 'package:flutter/material.dart';
import 'package:greenroute/screens/r_onboarding1.dart';
import 'package:greenroute/screens/td_onboarding1.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/button_small.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  // Function to save the selected role to SharedPreferences
  Future<void> _saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add some padding on the sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo or image at the top
              Flexible(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    "assets/garbage_truck.png",
                    height: screenHeight * 0.12, // Adjust based on screen height
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
                      fontSize: 28, // Reduce font size to fit on smaller screens
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
                    BtnSmall(
                      buttonText: "Resident",
                      onPressed: () async {
                        await _saveRole('resident');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ROnboarding1()),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03), // Adjust space between buttons
                    BtnSmall(
                      buttonText: "Truck Driver",
                      onPressed: () async {
                        await _saveRole('truck_driver');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TdOnboarding1()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
