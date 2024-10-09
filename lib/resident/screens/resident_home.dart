import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/new_button.dart';
import 'package:greenroute/theme.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import '../../common/widgets/home_header.dart';
import '../widgets/bottom_nav_resident.dart';
import 'emergency.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({super.key});

  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  String? userRole;
  String? userEmail;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
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
      return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
    }
    final screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loader if data is being fetched
          : Column(
        children: [
          SizedBox(
            // Pass userRole and userEmail to HomeHeader
            child: HomeHeader(
              userRole: userRole ?? "Guest", // Provide default values if null
              userEmail: userEmail ?? "Not Available",
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 7.0),
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
                          hintText: 'Track your truck',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Report an emergency',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            BtnNew(
                              width: 132,
                              height: 30,
                              buttonText: 'Report!',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  Emergency()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Add some spacing before the image
                    // Expanded Image Section
                    Expanded(
                      child: Image.asset(
                        'assets/resident_home.png',
                        fit: BoxFit.contain, // Adjusts the image to fit the space
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomNavR(
            current: 'home',
          ),
        ],
      ),
    );
  }
}
