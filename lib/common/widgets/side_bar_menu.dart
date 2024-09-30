import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart'; // Import your theme

class SideBarMenu extends StatelessWidget {
  final String menuText;
  final Icon menuIcon;

  const SideBarMenu(
      {super.key, required this.menuText, required this.menuIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          SizedBox(
            width: 27,
            height: 27,
            child: Icon(
              menuIcon.icon, // Access the icon from menuIcon
              size: 27, // Set icon size
              color: AppColors.textColor, // Set icon color
            ),
          ),
          const SizedBox(width: 15),
          Text(
            menuText,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
