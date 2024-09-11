import 'package:flutter/material.dart';
import 'package:greenroute/screens/onboarding_last.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/skip_button.dart';

class ROnboarding2 extends StatelessWidget {
  const ROnboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Resident Onboarding 2",
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 142,
              ),
              Image.asset(
                "assets/r_onboarding2.png",
                height: 245,
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                width: 288,
                height: 126,
                child: Text(
                  "Stay updated on collection times and special requests.",
                  style: AppTextStyles.onboardingText,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: 55,
                height: 8,
                child: Stack(
                  children: [
                    Positioned(
                      left: 47,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 0,
                      child: Container(
                        width: 31,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SkipButton(
                    onPressed: () {
                      // Navigate to OnboardingLast page when Skip is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OnboardingLast(), // No parentheses after OnboardingLast if no arguments are needed
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
