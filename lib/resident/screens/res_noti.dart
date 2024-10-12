import 'package:flutter/material.dart';
import 'package:greenroute/resident/widgets/bottom_nav_resident.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../theme.dart';

class ResidentNotificationPage extends StatelessWidget {
  const ResidentNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                SizedBox(height: 55.0),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Notification",
                    style: AppTextStyles.topic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFFA7A6A6)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search for Notifications',
                    style: TextStyle(
                      color: Color(0xFFA7A6A6),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Notification list
          Expanded(
            child: ListView(
              children: [
                NotificationTile(
                  initials: 'RP',
                  title: 'Report Accepted',
                  details:
                      'Your submitted report has been accepted.\nDate: 2024/08/21\nTime: 10:00 a.m',
                  time: timeago.format(
                      DateTime.now().subtract(const Duration(minutes: 10))),
                  backgroundColor: const Color(0xFFEDFFEE),
                ),
                NotificationTile(
                  initials: 'RP',
                  title: 'Report Processing',
                  details:
                      'Your submitted report is being processed.\nDate: 2024/08/22\nTime: 11:30 a.m',
                  time: timeago.format(
                      DateTime.now().subtract(const Duration(hours: 3))),
                ),
                NotificationTile(
                  initials: 'RP',
                  title: 'Report Rejected',
                  details:
                      'Your submitted report has been rejected. Please check your submission.\nDate: 2024/08/23\nTime: 2:00 p.m',
                  time: timeago.format(
                      DateTime.now().subtract(const Duration(hours: 5))),
                ),
              ],
            ),
          ),
          BottomNavR(current: 'notification')
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String initials;
  final String title;
  final String details;
  final String time;
  final Color? backgroundColor;

  const NotificationTile({
    super.key,
    required this.initials,
    required this.title,
    required this.details,
    required this.time,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE2E8F0),
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF72839A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
