import 'package:flutter/material.dart';
import '../../theme.dart';

class SubmitCancelButtons extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitCancelButtons({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back on cancel
          },
          child: Container(
            width: 102,
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFF7F1111),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Center(
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            width: 102,
            height: 40,
            decoration: ShapeDecoration(
              color: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Center(
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
