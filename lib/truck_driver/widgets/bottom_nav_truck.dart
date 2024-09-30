import 'package:flutter/material.dart';

import '../../theme.dart';


class BottomNavTD extends StatelessWidget{
  final String current;

  const BottomNavTD({super.key, required this.current});

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
                MaterialPageRoute(builder: (context) => const TdHome()),
              ); // Navigate to Home screen
            },
            child: home(current), // Home icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TdSchedule()),
              );// Navigate to Schedule screen
            },
            child: schedule(current), // Schedule icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TdNotification()),
              );// Navigate to Notification screen
            },
            child: notification(current), // Notification icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TdProfile()),
              ); // Navigate to Profile screen
            },
            child: profile(current), // Profile icon
          ),     // Profile icon
        ],
      ),
    );
  }

  Widget home(String current){
    if(current == "home"){
      return const TIconTrue(bottomIcon: Icon(Icons.home));
    }
    else{
      return const TIconFalse(bottomIcon: Icon(Icons.home));
    }
  }

  Widget schedule(String current){
    if(current == "schedule"){
      return const TIconTrue(bottomIcon: Icon(Icons.schedule));
    }
    else{
      return const TIconFalse(bottomIcon: Icon(Icons.schedule));
    }
  }

  Widget notification(String current){
    if(current == "notification"){
      return const TIconTrue(bottomIcon: Icon(Icons.notifications));
    }
    else{
      return const TIconFalse(bottomIcon: Icon(Icons.notifications));
    }
  }

  Widget profile(String current){
    if(current == "profile"){
      return const TIconTrue(bottomIcon: Icon(Icons.person));
    }
    else{
      return const TIconFalse(bottomIcon: Icon(Icons.person));
    }
  }

}

class TIconTrue extends StatelessWidget{
  final Icon bottomIcon;

  const TIconTrue({super.key, required this.bottomIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 75,
      color: AppColors.primaryColor,
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(bottomIcon.icon,
            color: AppColors.backgroundColor,
          ),
        ),
      ) ,
    );
  }

}

class TIconFalse extends StatelessWidget{
  final Icon bottomIcon;

  const TIconFalse({super.key, required this.bottomIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(bottomIcon.icon,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

