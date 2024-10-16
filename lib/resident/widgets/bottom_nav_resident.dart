import 'package:flutter/material.dart';
import 'package:greenroute/resident/screens/resident_home.dart';

import '../../theme.dart';
import '../../common/screens/profile.dart';
import '../screens/res_noti.dart';

class BottomNavR extends StatelessWidget{
   final String current;

  const BottomNavR({super.key, required this.current});

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
                MaterialPageRoute(builder: (context) => const ResidentHome()),
              );// Navigate to Home screen
            },
            child: home(current), // Home icon
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResidentNotificationPage()),
              ); // Navigate to Notification screen
            },
            child: notification(current), // Notification icon
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
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
     return const RIconTrue(bottomIcon: Icon(Icons.home));
   }
   else{
     return const RIconFalse(bottomIcon: Icon(Icons.home));
   }
  }

   Widget notification(String current){
     if(current == "notification"){
       return const RIconTrue(bottomIcon: Icon(Icons.notifications));
     }
     else{
       return const RIconFalse(bottomIcon: Icon(Icons.notifications));
     }
   }

   Widget profile(String current){
     if(current == "profile"){
       return const RIconTrue(bottomIcon: Icon(Icons.person));
     }
     else{
       return const RIconFalse(bottomIcon: Icon(Icons.person));
     }
   }

}

class RIconTrue extends StatelessWidget{
  final Icon bottomIcon;

  const RIconTrue({super.key, required this.bottomIcon});

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
          child: Icon(bottomIcon.icon,
            color: AppColors.backgroundColor,
          ),
        ),
      ) ,
    );
  }

}

class RIconFalse extends StatelessWidget{
  final Icon bottomIcon;

  const RIconFalse({super.key, required this.bottomIcon});

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

