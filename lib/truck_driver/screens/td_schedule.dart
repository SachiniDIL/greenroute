import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../common/widgets/new_button.dart';
import '../../theme.dart';
import '../widgets/bottom_nav_truck.dart';

class TDSchedule extends StatefulWidget {
  final String upcomingScheduleDetails;
  final String defaultDate; // Pass the default date

  const TDSchedule({
    super.key,
    required this.upcomingScheduleDetails,
    required this.defaultDate,
  });

  @override
  _TDScheduleState createState() => _TDScheduleState();
}

class _TDScheduleState extends State<TDSchedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? selectedDate;
  String? startTime;
  String? endTime;
  String? routeName;
  String? truckNumber;
  Map<DateTime, List<dynamic>> scheduledDates = {}; // Store scheduled dates
  String? userRole;
  String? userEmail;
  String? empId;
  bool isLoading = true;
  String dbURL = "https://greenroute-7251d-default-rtdb.firebaseio.com";
  bool scheduleFound = false;

  @override
  void initState() {
    super.initState();
    // Parse the defaultDate and set it as the selected date
    _selectedDay = DateTime.parse(widget.defaultDate);
    _focusedDay = _selectedDay!;
    _loadUserData(); // Load user data before fetching the schedule
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_role');
    userEmail = prefs.getString('user_email');
    empId = await _getEmpIdByEmail(userEmail!); // Fetch emp_id based on email

    if (empId != null) {
      // Fetch schedule only after empId is loaded
      await _fetchAllSchedules(); // Fetch all schedules
      await _fetchScheduleForSelectedDay(_selectedDay!); // Fetch schedule for the default date
    }

    setState(() {
      isLoading = false;
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
          return driverData['emp_id'];
        }
      } else {
        print('Failed to fetch empId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching empId: $e');
    }
    return null;
  }

  Future<void> _fetchAllSchedules() async {
    if (empId == null) {
      print('Error: empId is null.');
      return;
    }

    try {
      var response = await http.get(Uri.parse('$dbURL/route_schedules.json'));

      if (response.statusCode == 200) {
        var schedulesData = jsonDecode(response.body) as Map<String, dynamic>;

        schedulesData.forEach((routeId, routeSchedule) {
          routeSchedule.forEach((day, details) {
            if (details['truck_driver'] == empId) {
              DateTime scheduledDate = DateTime.parse(details['date']);
              scheduledDate = DateTime(
                  scheduledDate.year, scheduledDate.month, scheduledDate.day);
              if (scheduledDates.containsKey(scheduledDate)) {
                scheduledDates[scheduledDate]?.add(details);
              } else {
                scheduledDates[scheduledDate] = [details];
              }
            }
          });
        });

        print('Scheduled Dates: $scheduledDates');
        setState(() {}); // Trigger UI update
      } else {
        print('Error fetching schedule data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    }
  }

  Future<void> _fetchScheduleForSelectedDay(DateTime selectedDay) async {
    if (empId == null) return;

    // Format selectedDay to match the format in Firebase (YYYY-MM-DD)
    String selectedDayStr =
        "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";

    try {
      var response = await http.get(Uri.parse('$dbURL/route_schedules.json'));

      if (response.statusCode == 200) {
        var schedulesData = jsonDecode(response.body) as Map<String, dynamic>;
        bool scheduleFoundLocal = false;
        String? fetchedTruckNumber;

        for (var routeId in schedulesData.keys) {
          var routeSchedule = schedulesData[routeId];

          for (var day in routeSchedule.keys) {
            var details = routeSchedule[day];

            if (details['truck_driver'] == empId &&
                details['date'] == selectedDayStr) {
              selectedDate = selectedDay;
              startTime = details['start_time'];
              endTime = details['end_time'];
              routeName = routeId;

              // Fetch the truck number based on truck_id
              var truckResponse = await http.get(Uri.parse(
                  '$dbURL/truck.json?orderBy=%22truck_id%22&equalTo=%22${details['truck']}%22'));

              if (truckResponse.statusCode == 200) {
                var trucksData =
                jsonDecode(truckResponse.body) as Map<String, dynamic>;
                trucksData.forEach((key, truckDetails) {
                  fetchedTruckNumber = truckDetails['truck_number'];
                });
              }

              scheduleFoundLocal = true;
              break;
            }
          }

          if (scheduleFoundLocal) break;
        }

        setState(() {
          scheduleFound = scheduleFoundLocal;
          truckNumber = fetchedTruckNumber;
          if (!scheduleFoundLocal) {
            selectedDate = null;
            startTime = null;
            endTime = null;
            routeName = null;
            truckNumber = null;
          }
        });
      } else {
        print('Error fetching schedule data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
                    "Schedule for ${widget.defaultDate}",
                    style: AppTextStyles.topic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    _buildCalendar(),
                    SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'Job details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    Container(
                      decoration: ShapeDecoration(
                        color: AppColors.backgroundSecondColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            if (scheduleFound)
                              Column(
                                children: [
                                  _jobRow("Date",
                                      selectedDate?.toString() ?? 'N/A'),
                                  _jobRow(
                                      "Start time", startTime ?? 'N/A'),
                                  _jobRow("End time", endTime ?? 'N/A'),
                                  _jobRow("Route No", routeName ?? 'N/A'),
                                  _jobRow("Truck", truckNumber ?? 'N/A'),
                                  BtnNew(
                                    width: 130,
                                    height: 30,
                                    buttonText: "See route",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TruckDriverHome()),
                                      );
                                    },
                                  ),
                                ],
                              )
                            else
                              Text(
                                "No schedule found for the selected day.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          BottomNavTD(current: "schedule"),
        ],
      ),
    );
  }

  Widget _jobRow(String name, String? detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 30,
            child: Text(
              name,
              style: TextStyle(
                color: Color(0xFF525151),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 30,
            child: Text(
              ": ",
              style: TextStyle(
                color: Color(0xFF525151),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: Text(
                detail ?? 'N/A',
                style: TextStyle(
                  color: Color(0xFF535252),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _fetchScheduleForSelectedDay(selectedDay);
          });
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final scheduleDay = DateTime(day.year, day.month, day.day);
            if (scheduledDates.containsKey(scheduleDay)) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.buttonColor,
                  ),
                ),
              );
            }
            return null;
          },
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.green.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.buttonColor,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          titleTextStyle: TextStyle(
            color: AppColors.buttonColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.black),
          weekdayStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
