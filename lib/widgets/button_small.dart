import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class BtnSmall extends StatelessWidget {
  final String buttonText;

  // Constructor to accept the text dynamically
  const BtnSmall({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 239,
          height: 60,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 239,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 13.33,
                child: SizedBox(
                  width: 239,
                  height: 33.33,
                  child: Text(
                    buttonText, // Use the text from the constructor
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonTextSmall,
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
