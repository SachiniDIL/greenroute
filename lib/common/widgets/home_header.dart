import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 39.0),
          Image.asset("assets/app_name.png", height: 39),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingText('Good Morning,', 16),
                    _buildGreetingText('User', 15),
                    SizedBox(height: 10.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildGreetingText(String text, double fontSize) {
  return SizedBox(
    height: 23,
    child: Text(
      text,
      style: TextStyle(
        color: text == 'User' ? Color(0xFF5EA417) : Color(0xFF054700),
        fontSize: fontSize,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
