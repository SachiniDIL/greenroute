import 'package:flutter/material.dart';
import 'package:greenroute/screens/r_onboarding1.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/button_small.dart';

class OnboardingLast extends StatelessWidget {
  const OnboardingLast({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "last onboarding",
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              const SizedBox(
                height: 125,
              ),
              Center(
                child: Image.asset(
                  "assets/onboarding_last.png",
                  height: 240,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                width: 288,
                height: 54,
                child: Text(
                  "Stay updated on collection times and special requests.",
                  style: AppTextStyles.onboardingText,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 54,
              ),
              BtnSmall(
                buttonText: "Let's get started!",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ROnboarding1()),
                  );
                },
              ),
              const SizedBox(
                height: 109,
              ),
              SizedBox(
                width: 55,
                height: 8,
                child: Stack(
                  children: [
                    Positioned(
                      left: 24,
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
                      left: 12,
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
                height: 133,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
