import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenroute/truck_driver/widgets/bottom_nav_truck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import '../../theme.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});  // Remove const from here

  String? userRole;
  String? userEmail;
  bool isLoading = true;
  String? nextRouteDetails; // To store the next route details
  String? startTime; // To store the start time of the next route
  double precentage = 0;

  String? scheduledDate;
  String? upcomingScheduledDate;
  String? upcomingStartTime;
  String? upcomingRouteDetails; // To store upcoming route details
  String dbURL = "https://greenroute-7251d-default-rtdb.firebaseio.com";

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_role');
    userEmail = prefs.getString('user_email');
    await _getNextRouteDetails(); // Fetch the route details once the user data is loaded
    setState(() {
      isLoading = false; // Set loading to false once data is fetched
    });
  }

  Future<String?> _getEmpIdByEmail(String userEmail) async {
    try {
      var response = await http.get(
        Uri.parse('$dbURL/truck_driver.json?orderBy="email"&equalTo="$userEmail"'),
      );

      if (response.statusCode == 200) {
        var truckDriversData = jsonDecode(response.body) as Map<String, dynamic>;

        if (truckDriversData.isNotEmpty) {
          var driverData = truckDriversData.values.first;
          var empId = driverData['emp_id'];
          print("Employee ID: $empId");
          return empId;
        } else {
          print("No truck driver found for the provided email.");
        }
      } else {
        print('Error fetching truck driver data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<void> _getNextRouteDetails() async {
    if (userEmail != null) {
      String? empId = await _getEmpIdByEmail(userEmail!);

      if (empId == null) {
        print("No emp_id found for the user");
        return;
      }

      try {
        var scheduleResponse = await http.get(
          Uri.parse('$dbURL/route_schedules.json'),
        );

        if (scheduleResponse.statusCode == 200) {
          var scheduleData = jsonDecode(scheduleResponse.body) as Map<String, dynamic>;
          DateTime? soonestDate;
          String? soonestRouteId;
          String? soonestStartTime;

          for (var routeId in scheduleData.keys) {
            var route = scheduleData[routeId];

            for (var day in route.keys) {
              var schedule = route[day];

              if (schedule['truck_driver'] == empId) {
                scheduledDate = schedule['date'];
                DateTime scheduleDate = DateTime.parse(scheduledDate!);

                if (_isToday(scheduledDate!)) {
                  startTime = schedule['start_time'];
                  await _getRouteDetails(routeId, forToday: true);
                  setState(() {});
                  return;
                } else if (scheduleDate.isAfter(DateTime.now())) {
                  if (soonestDate == null || scheduleDate.isBefore(soonestDate)) {
                    soonestDate = scheduleDate;
                    soonestRouteId = routeId;
                    soonestStartTime = schedule['start_time'];
                  }
                }
              }
            }
          }

          if (soonestDate != null) {
            upcomingScheduledDate = soonestDate.toString().split(" ")[0];
            upcomingStartTime = soonestStartTime;
            await _getRouteDetails(soonestRouteId!, forToday: false);
            setState(() {});
          }
        } else {
          print('Error fetching route schedules: ${scheduleResponse.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print("User email is null.");
    }
  }

  Future<void> _getRouteDetails(String routeId, {required bool forToday}) async {
    try {
      var routeResponse = await http.get(
        Uri.parse('$dbURL/routes/$routeId.json'),
      );
      if (routeResponse.statusCode == 200) {
        var routeData = jsonDecode(routeResponse.body);

        if (routeData['intermediate_locations'] != null && routeData['intermediate_locations'] is List) {
          var intermediateLocations = routeData['intermediate_locations'] as List<dynamic>;

          var routeDetails = intermediateLocations
              .map((location) => location['location_name'])
              .take(3)
              .join(' -> ');

          setState(() {
            if (forToday) {
              nextRouteDetails = "$routeDetails ...";
            } else {
              upcomingRouteDetails = "$routeDetails ...";
            }
          });
        } else {
          setState(() {
            if (forToday) {
              nextRouteDetails = "No intermediate locations available";
            } else {
              upcomingRouteDetails = "No intermediate locations available";
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching route details: $e');
    }
  }

  bool _isToday(String date) {
    DateTime today = DateTime.now();
    DateTime scheduledDateParsed = DateTime.parse(date);

    return today.year == scheduledDateParsed.year &&
        today.month == scheduledDateParsed.month &&
        today.day == scheduledDateParsed.day;
  }

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

          // Search bar
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFFA7A6A6)),
                Expanded(
                  child: Text(
                    'Search for Notifications',
                    style: TextStyle(
                      color: Color(0xFFA7A6A6),
                      fontSize: 14,
                      fontFamily: 'Poppins',
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
                  initials: 'ND',
                  title: 'Normal Duty',
                  details: 'Date: 2024/08/21\nTime: 7.00 a.m - 9.00 a.m',
                  time: timeago.format(DateTime.now().subtract(const Duration(minutes: 2))),
                  backgroundColor: const Color(0xFFEDFFEE),
                ),
                NotificationTile(
                  initials: 'SD',
                  title: 'Special Duty',
                  details: 'Date: 2024/08/22\nTime: 10.00 a.m - 1.00 p.m',
                  time: timeago.format(DateTime.now().subtract(const Duration(hours: 20))),
                ),
                NotificationTile(
                  initials: 'ND',
                  title: 'Normal Duty',
                  details: 'Date: 2024/08/23\nTime: 2.00 p.m - 4.00 p.m',
                  time: timeago.format(DateTime.now().subtract(const Duration(hours: 8))),
                ),
                NotificationTile(
                  initials: 'SD',
                  title: 'Special Duty',
                  details: 'Date: 2024/08/24\nTime: 5.00 p.m - 7.00 p.m',
                  time: timeago.format(DateTime.now().subtract(const Duration(hours: 8))),
                ),
              ],
            ),
          ),
          BottomNavTD(current: 'notification')
        ],
      ),
    );
  }

  void setState(Null Function() param0) {}
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
