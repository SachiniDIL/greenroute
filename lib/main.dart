import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:greenroute/common/screens/select_role.dart';
import 'package:greenroute/resident/screens/resident_home.dart';
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GREENROUTE",
      home: SplashScreen(), // Set the initial screen to SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status during splash screen
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('is_logged_in');
    String? userRole = prefs.getString('user_role');

    // Simulate a short delay for the splash screen
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check if the user is logged in
    if (isLoggedIn == true && userRole != null) {
      // Navigate to the relevant home page based on the role
      if (userRole == 'resident') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResidentHome()),
        );
      } else if (userRole == 'truck_driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TruckDriverHome()),
        );
      }
    } else {
      // If not logged in, navigate to the role selection screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectRole()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/garbage_truck.png',
          height: 100,
        ),
      ),
    );
  }
}
