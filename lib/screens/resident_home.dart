import 'package:flutter/material.dart';
import 'package:greenroute/screens/td_onboarding1.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/widgets/button_large.dart';
import '../widgets/bottom_nav_resident.dart';
import '../widgets/button_small.dart';
import '../widgets/sidebar.dart';

class ResidentHome extends StatelessWidget {
  const ResidentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Resident Home",
      home: Scaffold(
        drawer: const SideBar(),
        body: Stack(
          children: [
            // Scrollable content goes here
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 127),
              // Add padding to account for the fixed container height
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // Align the text to the right
                      children: [
                        Text(
                          'Upcoming Collection',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.backgroundSecondColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "Time",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 41,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // Align the text to the right
                      children: [
                        Text(
                          'Log Garbage Bags',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 111,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.backgroundSecondColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.delete_sharp,
                                        size: 50,
                                        color: Color.fromRGBO(12, 147, 0, 1),
                                      ),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.delete_sharp,
                                        size: 50,
                                        color: Color.fromRGBO(147, 0, 0, 1),
                                      ),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.delete_sharp,
                                        size: 50,
                                        color: Color.fromRGBO(0, 32, 147, 1),
                                      ),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    BtnSmall(
                      buttonText: "Special Request",
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TdOnboarding1()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Container at the top
            Container(
              height: 127,
              decoration: const BoxDecoration(
                color: AppColors.backgroundSecondColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/app_name.png",
                          height: 22,
                        ),
                        const SizedBox(width: 20),
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Hello, ",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "User Name",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavR(current: "home"),
      ),
    );
  }
}
