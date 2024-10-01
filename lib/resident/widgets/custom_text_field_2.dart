import 'package:flutter/material.dart';
import '../../theme.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled; // Add enabled parameter

  const CustomTextField2({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true, // Default to enabled
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2, // Adjusts the space given to the label
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        const SizedBox(width: 10), // Adds space between label and input
        Expanded(
          flex: 3, // Adjusts the space given to the text field
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled, // Use the enabled parameter
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
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixTap,
              )
                  : null,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
