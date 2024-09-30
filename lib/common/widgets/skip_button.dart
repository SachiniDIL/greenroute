import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the navigation when button is clicked
      child: const Text(
        "Skip",
        style: AppTextStyles.skip,
      ),
    );
  }
}
