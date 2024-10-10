import 'package:flutter/material.dart';
import 'package:greenroute/common/screens/profile.dart';
import 'package:greenroute/disposal_officer/screens/do_home.dart';
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';

import '../../theme.dart';

class BottomNavDO extends StatelessWidget {
  final String current;

  const BottomNavDO({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      color: AppColors.backgroundSecondColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space icons evenly
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DOHome()),
              ); // Navigate to Home screen
            },
            child: home(current), // Home icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DOHome()),
              ); // Navigate to Schedule screen
            },
            child: schedule(current), // Schedule icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DOHome()),
              ); // Navigate to Notification screen
            },
            child: notification(current), // Notification icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              ); // Navigate to Profile screen
            },
            child: profile(current), // Profile icon
          ), // Profile icon
        ],
      ),
    );
  }

  Widget home(String current) {
    if (current == "home") {
      return const TIconTrue(bottomIcon: Icon(Icons.home));
    } else {
      return const TIconFalse(bottomIcon: Icon(Icons.home));
    }
  }

  Widget schedule(String current) {
    if (current == "schedule") {
      return const TIconTrue(bottomIcon: Icon(Icons.schedule));
    } else {
      return const TIconFalse(bottomIcon: Icon(Icons.schedule));
    }
  }

  Widget notification(String current) {
    if (current == "notification") {
      return const TIconTrue(bottomIcon: Icon(Icons.notifications));
    } else {
      return const TIconFalse(bottomIcon: Icon(Icons.notifications));
    }
  }

  Widget profile(String current) {
    if (current == "profile") {
      return const TIconTrue(bottomIcon: Icon(Icons.person));
    } else {
      return const TIconFalse(bottomIcon: Icon(Icons.person));
    }
  }
}

class TIconTrue extends StatelessWidget {
  final Icon bottomIcon;

  const TIconTrue({super.key, required this.bottomIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.primaryColor,
      ),
      height: 40,
      width: 75,
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            bottomIcon.icon,
            color: AppColors.backgroundColor,
          ),
        ),
      ),
    );
  }
}

class TIconFalse extends StatelessWidget {
  final Icon bottomIcon;

  const TIconFalse({super.key, required this.bottomIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          bottomIcon.icon,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
