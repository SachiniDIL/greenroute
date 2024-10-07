import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/custom_table.dart';
import 'package:greenroute/common/widgets/home_header.dart';
import 'package:greenroute/common/widgets/new_button.dart';
import 'package:greenroute/disposal_officer/screens/disposal_history.dart';

import '../../theme.dart';
import '../../truck_driver/screens/truck_driver_home.dart';
import '../widgets/bottom_nav_do.dart';
import 'new_disposal.dart';

class DOHome extends StatelessWidget {
  // Remove const from constructor since garbageTotal is mutable
  DOHome({super.key});

  double garbageTotal = 999;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: HomeHeader(),
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
                      height: 7.0,
                    ),
                    Container(
                      height: 52.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'search for truck details',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 160,
                            decoration: ShapeDecoration(
                              color: AppColors.backgroundSecondColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'New Disposal',
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
                                    height: 40,
                                  ),
                                  BtnNew(
                                    width: double.infinity,
                                    height: 45,
                                    buttonText: "Add new disposal",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NewDisposal(),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 160,
                            decoration: ShapeDecoration(
                              color: AppColors.backgroundSecondColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Garbage Total',
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
                                    height: 37,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: garbageTotal.toString(),
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.6399999856948853),
                                            fontSize: 40,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' mt',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.6399999856948853),
                                            fontSize: 24,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
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
                      height: 30,
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
                              'Truck Details',
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
                            CustomTable(rows: [
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
                            ]),
                            SizedBox(
                              height: 15.0,
                            ),
                            BtnNew(
                              width: 170.0,
                              height: 35.0,
                              buttonText: 'See more',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisposalHistory()),
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
          BottomNavDO(
            current: 'home',
          ),
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
