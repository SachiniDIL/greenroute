import 'package:flutter/material.dart';
import 'package:greenroute/theme.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 31.0, bottom: 31.0, right: 20.0, left: 20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Feedback()),
                );// Navigate to Feedback screen
              },
              child: const SideBarMenu(
                menuText: "Feedback",
                menuIcon: Icon(Icons.feedback),
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Report()),
                ); // Navigate to Report screen
              },
              child: const SideBarMenu(
                menuText: "Report",
                menuIcon: Icon(Icons.report),
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Support()),
                ); // Navigate to Support screen
              },
              child: const SideBarMenu(
                menuText: "Support",
                menuIcon: Icon(Icons.support),
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Logout()),
                ); // Navigate to Logout or perform logout
              },
              child: const SideBarMenu(
                menuText: "Logout",
                menuIcon: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideBarMenu extends StatelessWidget {
  final String menuText;
  final Icon menuIcon;

  const SideBarMenu({super.key, required this.menuText, required this.menuIcon});

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
          const SizedBox(
            width: 15,
          ),
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
