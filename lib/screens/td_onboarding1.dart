import 'package:flutter/material.dart';
import 'package:greenroute/screens/td_onboarding2.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/skip_button.dart';

class TdOnboarding1 extends StatelessWidget {
  const TdOnboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "truck driver onboarding 1",
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              Image.asset(
                "assets/td_onboarding1.png",
                height: 245,
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                width: 288,
                height: 126,
                child: Text(
                  "Navigate your route with real-time updates and ease.",
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
                          color: Colors.black.withOpacity(0.20000000298023224),
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 35,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.20000000298023224),
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 31,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.20000000298023224),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SkipButton(
                    onPressed: () {
                      // Navigate to the NextPage when Skip is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TdOnboarding2()), // Replace with desired page
                      );
                    },
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
