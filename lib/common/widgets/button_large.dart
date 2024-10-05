import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class BtnLarge extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const BtnLarge({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Sign-Up Button Pressed');
        onPressed();
      },
      child: Column(
        children: [
          SizedBox(
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
                          color: Color.fromARGB(116, 58, 58, 58),
                          blurRadius: 3,
                          offset: Offset(0, 3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                // Use Center to ensure the text fits properly
                Center(
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonTextLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
