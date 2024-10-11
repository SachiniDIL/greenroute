import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenroute/disposal_officer/screens/disposal_history.dart';
import 'package:greenroute/truck_driver/screens/fuel.dart';
import 'package:greenroute/truck_driver/screens/route_map.dart';
import 'package:greenroute/truck_driver/screens/td_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

import '../../common/widgets/custom_table.dart';
import '../../common/widgets/home_header.dart';
import '../../common/widgets/new_button.dart';
import '../widgets/bottom_nav_truck.dart';
import '../../theme.dart';

class TruckDriverHome extends StatefulWidget {
  const TruckDriverHome({super.key});

  @override
  _TruckDriverHomeState createState() => _TruckDriverHomeState();
}

class _TruckDriverHomeState extends State<TruckDriverHome> {
  List<Map<String, dynamic>> latestDisposals = [];

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

  @override
  void initState() {
    super.initState();
    _initializeData();  // Call the new method to ensure the proper sequence
  }

  Future<void> _initializeData() async {
    await _loadUserData(); // Wait for user data to load
    _getLatestDisposalRecords(); // Fetch the latest disposal records here
  }

  // Method to load user_role and user_email from SharedPreferences
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
      // Step 1: Fetch all truck drivers
      var response = await http.get(
        Uri.parse('$dbURL/truck_driver.json?orderBy="email"&equalTo="$userEmail"'),
      );

      if (response.statusCode == 200) {
        var truckDriversData = jsonDecode(response.body) as Map<String, dynamic>;

        // Step 2: Check if the response contains a valid truck driver
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
        // Step 1: Fetch the entire route schedule
        var scheduleResponse = await http.get(
          Uri.parse('$dbURL/route_schedules.json'),
        );

        if (scheduleResponse.statusCode == 200) {
          var scheduleData = jsonDecode(scheduleResponse.body) as Map<String, dynamic>;
          DateTime? soonestDate; // Track the soonest available date
          String? soonestRouteId;
          String? soonestStartTime;

          // Step 2: Loop through each route and its days
          for (var routeId in scheduleData.keys) {
            var route = scheduleData[routeId];

            // Step 3: Loop through each day inside the route
            for (var day in route.keys) {
              var schedule = route[day];

              // Step 4: Compare truck_driver with empId
              if (schedule['truck_driver'] == empId) {
                scheduledDate = schedule['date'];
                DateTime scheduleDate = DateTime.parse(scheduledDate!);

                if (_isToday(scheduledDate!)) {
                  startTime = schedule['start_time']; // Set startTime for today
                  await _getRouteDetails(routeId, forToday: true); // Fetch and set today's route details
                  setState(() {
                    // Rebuild the UI after data is fetched
                  });
                  return;
                } else if (scheduleDate.isAfter(DateTime.now())) {
                  // Check if this is the soonest upcoming date
                  if (soonestDate == null || scheduleDate.isBefore(soonestDate)) {
                    soonestDate = scheduleDate;
                    soonestRouteId = routeId;
                    soonestStartTime = schedule['start_time'];
                  }
                }
              }
            }
          }

          // If there's no schedule for today but there is an upcoming schedule
          if (soonestDate != null) {
            upcomingScheduledDate = soonestDate.toString().split(" ")[0];
            upcomingStartTime = soonestStartTime;
            await _getRouteDetails(soonestRouteId!, forToday: false); // Fetch and set upcoming route details
            setState(() {
              // Rebuild the UI after upcoming schedule is fetched
            });
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
      // Fetch route details
      var routeResponse = await http.get(
        Uri.parse('$dbURL/routes/$routeId.json'),
      );
      if (routeResponse.statusCode == 200) {
        var routeData = jsonDecode(routeResponse.body);

        // Check if intermediate_locations exists and is a list
        if (routeData['intermediate_locations'] != null &&
            routeData['intermediate_locations'] is List) {
          var intermediateLocations = routeData['intermediate_locations'] as List<dynamic>;

          // Store the first three intermediate locations to display
          var routeDetails = intermediateLocations
              .map((location) => location['location_name'])
              .take(3)
              .join(' -> ');

          setState(() {
            if (forToday) {
              nextRouteDetails = "$routeDetails ..."; // Today's route
            } else {
              upcomingRouteDetails = "$routeDetails ..."; // Upcoming route
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

  Future<void> _getLatestDisposalRecords() async {
    if (userEmail != null) {
      print("User Email: $userEmail");  // Debugging point

      String? empId = await _getEmpIdByEmail(userEmail!);
      print("Emp ID: $empId");  // Debugging point

      if (empId == null) {
        print("No emp_id found for the user");
        return;
      }

      try {
        // Step 1: Fetch disposal records
        var disposalResponse = await http.get(
          Uri.parse('$dbURL/disposal.json'),
        );

        if (disposalResponse.statusCode == 200) {
          var disposalData = jsonDecode(disposalResponse.body) as Map<String, dynamic>;

          print("Disposal Data: $disposalData");  // Debugging point

          // Step 2: Filter records by truck_driver == empId
          List<Map<String, dynamic>> filteredDisposals = disposalData.entries
              .where((entry) => entry.value['truck_driver'] == empId)
              .map((entry) => {
            'date': entry.value['date'],
            'time': entry.value['time'],
            'disposal_weight': entry.value['disposal_weight'],
          })
              .toList();

          // Step 3: Sort the filtered disposals by date (newest first)
          filteredDisposals.sort((a, b) {
            DateTime dateA = DateTime.parse(a['date']);
            DateTime dateB = DateTime.parse(b['date']);
            return dateB.compareTo(dateA); // Sort in descending order
          });

          // Step 4: Take the latest 4 disposals
          latestDisposals = filteredDisposals.take(4).toList();

          print("Latest Disposals: $latestDisposals");  // Debugging point

          setState(() {
            // Rebuild UI to show the latest disposals
          });
        } else {
          print('Error fetching disposal records: ${disposalResponse.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print("User email is null.");
    }
  }

  bool _isToday(String date) {
    DateTime today = DateTime.now();
    DateTime scheduledDateParsed = DateTime.parse(date); // Assuming date is in the format 'yyyy-MM-dd'

    return today.year == scheduledDateParsed.year &&
        today.month == scheduledDateParsed.month &&
        today.day == scheduledDateParsed.day;
  }

  Future<void> _showExitConfirmationDialog() async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // Exit the app
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      );
    }

    bool isTodayScheduled = scheduledDate != null && _isToday(scheduledDate!);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          // Show exit confirmation dialog when the user presses back
          await _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondColor,
        body: Column(
          children: [
            SizedBox(
              child: HomeHeader(
                userRole: userRole ?? "Guest",
                userEmail: userEmail ?? "Not Available",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
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
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: Text(
                          'Latest Job',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      if (isTodayScheduled)
                        _buildJobContainer(nextRouteDetails, startTime, "Start Now", true)
                      else
                        Column(
                          children: [
                            Text(
                              "No trip scheduled for today",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            if (upcomingScheduledDate != null)
                              _buildJobContainer(upcomingRouteDetails, upcomingStartTime, "View Schedule", false),
                          ],
                        ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Divider(
                        thickness: 0.7,
                      ),
                      SizedBox(
                        height: 23.0,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: AppColors.backgroundSecondColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Oil quarter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6399999856948853),
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  height: 0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  double totalWidth = constraints.maxWidth;
                                  double presentageWidth = (totalWidth * precentage) / 100;

                                  return Stack(
                                    children: [
                                      Container(
                                        height: 15.0,
                                        width: totalWidth,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 15.0,
                                        width: presentageWidth,
                                        decoration: ShapeDecoration(
                                          color: AppColors.buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            height: 15.0,
                                            width: presentageWidth,
                                            decoration: ShapeDecoration(
                                              color: AppColors.buttonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft: Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                            width: presentageWidth,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "$precentage%",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              BtnNew(
                                width: 170.0,
                                height: 35.0,
                                buttonText: 'Check quarter',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FuelPage()),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildTruckDetailsTable(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavTD(current: "home"),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckDetailsTable() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.backgroundSecondColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Latest Disposal History',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.64),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 15.0),
            CustomTable(rows: _buildTableRows()),
            SizedBox(height: 15.0),
            BtnNew(
              width: 170.0,
              height: 35.0,
              buttonText: 'See more',
              onPressed: () async {
                // Fetch the empId first
                String? empId = await _getEmpIdByEmail(userEmail!);

                // Then pass the empId to the DisposalHistory page
                if (empId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisposalHistory(truckDriver: empId), // Pass the empId as the truckDriver parameter
                    ),
                  );
                } else {
                  print("No truck driver found for the current user.");
                }
              },
            ),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [
      TableRow(
        children: [
          _buildTableCell("Date"),
          _buildTableCell("Time"),
          _buildTableCell("Weight"),
        ],
      ),
    ];

    if (isLoading) {
      rows.add(
        TableRow(
          children: [
            _buildTableCell("Loading..."),
            _buildTableCell(""),
            _buildTableCell(""),
          ],
        ),
      );
    } else {
      for (var disposal in latestDisposals) {
        rows.add(
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border(top: BorderSide(width: 2, color: Color(0xFFD1CFD7))),
            ),
            children: [
              _buildTableCell(disposal['date']),
              _buildTableCell(disposal['time']),
              _buildTableCell(disposal['disposal_weight'].toString()),
            ],
          ),
        );
      }
    }

    return rows;
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF686868),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildJobContainer(
      String? routeDetails, String? startTime, String buttonText, bool isToday) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: ShapeDecoration(
        color: AppColors.backgroundSecondColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            routeDetails ?? "No route assigned",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            startTime ?? "N/A",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          SizedBox(height: 10.0),
          BtnNew(
            width: 170,
            height: 35,
            buttonText: buttonText,
            onPressed: () {
              if (isToday) {
                // For the current day's schedule, navigate to RouteMap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteMap(
                      routeDetails: routeDetails!,
                      startLocation: LatLng(6.9271, 79.8612), // Example start location
                      endLocation: LatLng(6.9271, 79.9000),   // Example end location
                    ),
                  ),
                );
              } else {
                // For upcoming schedules, navigate to TDSchedule
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TDSchedule(
                      upcomingScheduleDetails: routeDetails!,  // Pass route details
                      defaultDate: upcomingScheduledDate!,     // Pass scheduled date
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
