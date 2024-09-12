import 'package:flutter/material.dart';
import 'package:greenroute/screens/r_onboarding1.dart';
import 'package:greenroute/screens/td_onboarding1.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/button_small.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  // Function to save the selected role to SharedPreferences
  Future<void> _saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role); // Store the selected role as 'resident' or 'truck_driver'
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch widgets horizontally to fill the space
          children: [
            const SizedBox(
              height: 134,
            ),
            const Spacer(),
            Center(
              child: Image.asset(
                "assets/garbage_truck.png",
                height: 84,
              ),
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Select Your Role',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 36,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: BtnSmall(
                buttonText: "Resident",
                onPressed: () async {
                  // Save role as 'resident' and navigate to Resident Onboarding
                  await _saveRole('resident');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ROnboarding1()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: BtnSmall(
                buttonText: "Truck Driver",
                onPressed: () async {
                  // Save role as 'truck_driver' and navigate to Truck Driver Onboarding
                  await _saveRole('truck_driver');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TdOnboarding1()),
                  );
                },
              ),
            ),
            const Spacer(),
            const SizedBox(
              height: 316,
            )
          ],
        ),
      ),
    );
  }
}
