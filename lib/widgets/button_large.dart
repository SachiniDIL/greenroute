import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class BtnLarge extends StatelessWidget {
  final String buttonText;

  // Constructor to accept the text dynamically
  const BtnLarge({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 265,
          height: 60,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 265,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: AppColors.textColor,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 91,
                top: 12.19,
                child: SizedBox(
                  width: 82,
                  height: 36.61,
                  child: Text(
                    buttonText, // Use the text passed from the constructor
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonTextLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
