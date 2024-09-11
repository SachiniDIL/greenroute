import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/button_small.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Stretch widgets horizontally to fill the space
          children: [
            SizedBox(
              height: 134,
            ),
            // The Spacer will divide the space equally between the widgets
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

            const Center(
              child: BtnSmall(
                buttonText: "Resident",
              ),
            ),

            SizedBox(
              height: 30,
            ),

            const Center(
              child: BtnSmall(
                buttonText: "Truck Driver",
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
