import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class BtnNew extends StatelessWidget {
  // Parameters for the button
  final double width;// Width of the button
  final double height;
  final String buttonText; // Text on the button
  final VoidCallback onPressed;

  // Function to execute when the button is pressed

  // Constructor to initialize the parameters
  const BtnNew({
    Key? key,
    required this.width,
    required this.height,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Set the width from the passed parameter
      height: height,
      decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), // Height can be adjusted as needed
      child: ElevatedButton(
        onPressed: onPressed, // Trigger the onPressed function when tapped
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor, // Background color
        ),
        child: Text(
          buttonText, // Display the button text
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
    );
  }
}
