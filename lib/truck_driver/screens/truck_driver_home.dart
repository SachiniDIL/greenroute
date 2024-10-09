import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/home_header.dart';
import 'package:greenroute/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/widgets/custom_table.dart';
import '../../common/widgets/new_button.dart';
import '../widgets/bottom_nav_truck.dart';

class TruckDriverHome extends StatefulWidget {
  TruckDriverHome({super.key});

  @override
  _TruckDriverHomeState createState() => _TruckDriverHomeState();
}

class _TruckDriverHomeState extends State<TruckDriverHome> {
  String? userRole;
  String? userEmail;
  bool isLoading = true;
  double precentage = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Method to load user_role and user_email from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      userEmail = prefs.getString('user_email');
      isLoading = false; // Set loading to false once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader
          : Column(
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
                    Row(
                      children: [
                        Container(
                          width: 160,
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
                                "Kaduwela - Malabe\n11.00 AM",
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
                              BtnNew(
                                width: 115,
                                height: 25,
                                buttonText: "Start Now",
                                onPressed: () {
                                  // Add action or navigation here
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.7,
                          ),
                        ),
                      ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Oil quarter',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.6399999856948853),
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
                                double presentageWidth =
                                    (totalWidth * precentage) / 100;

                                return Stack(
                                  children: [
                                    Container(
                                      height: 15.0,
                                      width: totalWidth,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                              width: 150.0,
                              height: 35.0,
                              buttonText: 'Check quarter',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TruckDriverHome()),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Latest Disposal History',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.6399999856948853),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w900,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            CustomTable(
                              rows: [
                                TableRow(
                                  children: [
                                    _buildTableCell("001"),
                                    _buildTableCell("Task 1"),
                                    _buildTableCell("Medium"),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    border: Border(
                                      top: BorderSide(
                                        width: 2,
                                        color: Color(0xFFD1CFD7),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '001',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF232326),
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 0.20,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Water leakage',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF232326),
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 0.20,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'High',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF232326),
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 0.20,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            BtnNew(
                              width: 170.0,
                              height: 35.0,
                              buttonText: 'Check full history',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TruckDriverHome()),
                                );
                              },
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomNavTD(current: "home"),
        ],
      ),
    );
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
}
