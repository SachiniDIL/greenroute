import 'package:flutter/material.dart';
import '../theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final int maxLines; // Add maxLines parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.maxLines = 1, // Default to 1 line if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.formText),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines, // Use maxLines for multiline input
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.buttonColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
            suffixIcon: suffixIcon != null
                ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: onSuffixTap,
            )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
