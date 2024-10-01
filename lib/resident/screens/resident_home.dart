import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenroute/resident/screens/log_garbage_bags.dart';
import 'package:greenroute/resident/screens/special_request.dart';
import 'package:greenroute/theme.dart';
import '../widgets/bottom_nav_resident.dart';
import '../../common/widgets/button_small.dart';
import '../../common/widgets/sidebar.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({super.key});

  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  int plasticBags = 0;
  int paperBags = 0;
  int foodBags = 0;
  String firstName = ''; // Variable to hold the first name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from SharedPreferences and Firebase
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    if (userEmail != null) {
      _fetchGarbageLog(userEmail);
      _fetchUserName(userEmail); // Fetch the user name (first name)
    }
  }

  // Fetch user data from Firebase to get the first name
  Future<void> _fetchUserName(String userEmail) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
    Query query = dbRef.orderByChild('email').equalTo(userEmail);

    DataSnapshot snapshot = await query.get();
    if (snapshot.exists) {
      final userData = Map<dynamic, dynamic>.from(snapshot.value as Map);
      if (userData.isNotEmpty) {
        final userEntry = userData.values.first as Map<dynamic, dynamic>;
        String fullName = userEntry['fullName'] ?? '';
        setState(() {
          firstName = fullName.split(' ')[0]; // Get the first name
        });
      }
    }
  }

  // Fetch garbage logs from Firebase
  Future<void> _fetchGarbageLog(String userEmail) async {
    DatabaseReference dbRef =
    FirebaseDatabase.instance.ref().child('garbage_logs');
    Query query = dbRef.orderByChild('user_email').equalTo(userEmail);

    DataSnapshot snapshot = await query.get();
    if (snapshot.exists) {
      // Cast the snapshot value to Map<dynamic, dynamic>
      final logEntries = Map<dynamic, dynamic>.from(snapshot.value as Map);
      if (logEntries.isNotEmpty) {
        // Cast the first entry properly
        final firstEntry = logEntries.values.first as Map<dynamic, dynamic>;

        setState(
              () {
            plasticBags = (firstEntry['plastic_bags'] ?? 0) as int;
            paperBags = (firstEntry['paper_bags'] ?? 0) as int;
            foodBags = (firstEntry['food_bags'] ?? 0) as int;
          },
        );
      }
    }
  }

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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                    const SizedBox(height: 41),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogGarbage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildBagIconAndCount(
                                        Icons.delete_sharp,
                                        plasticBags,
                                        const Color.fromRGBO(12, 147, 0, 1)),
                                    _buildBagIconAndCount(
                                        Icons.delete_sharp,
                                        paperBags,
                                        const Color.fromRGBO(147, 0, 0, 1)),
                                    _buildBagIconAndCount(
                                        Icons.delete_sharp,
                                        foodBags,
                                        const Color.fromRGBO(0, 32, 147, 1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    BtnSmall(
                      buttonText: "Special Request",
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SpecialRequest()),
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
                    Row(
                      children: [
                        const Text(
                          "Hello, ",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          firstName.isNotEmpty ? firstName : "User Name", // Display first name
                          style: const TextStyle(
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

  // Helper method to build icon and count widget
  Widget _buildBagIconAndCount(IconData icon, int count, Color color) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: Icon(
              icon,
              size: 50,
              color: color,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
