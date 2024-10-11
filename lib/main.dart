import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:greenroute/disposal_officer/screens/do_home.dart';
import 'package:greenroute/common/screens/select_role.dart';
import 'package:greenroute/resident/screens/resident_home.dart';
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Function to handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up FCM background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GREENROUTE",
      home: SplashScreen(),
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
    _checkLoginStatus();
    _setupFCM(); // Initialize FCM
  }

  // Function to check login status
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('logged');
    String? userRole = prefs.getString('user_role');

    // Simulate a short delay for the splash screen
    await Future.delayed(const Duration(milliseconds: 1000));

    // Navigate based on the user role
    if (isLoggedIn == true && userRole != null) {
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
      } else if (userRole == 'disposal_officer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DOHome()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectRole()),
      );
    }
  }

  // Function to set up Firebase Messaging for notifications
  Future<void> _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');

      // Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print('Received a foreground message: ${message.notification!.body}');
          // Show notification in-app
        }
      });

      // Handle background notification tap
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification clicked!');
        // Handle notification click event
      });

      // Get FCM token (optional: useful for targeting devices)
      String? token = await messaging.getToken();
      print("FCM Token: $token");


    } else {
      print('User declined or has not accepted permission');
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
