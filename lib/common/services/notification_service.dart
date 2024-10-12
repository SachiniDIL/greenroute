import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Replace with your app icon

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> getTruckDriverDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('user_email');
    final userRole = prefs.getString('user_role');

    if (userRole == 'truck_driver') {
      DatabaseReference ref = FirebaseDatabase.instance.ref('truck_driver');

      // Fetch driver details by email
      DatabaseEvent event = await ref.orderByChild('email').equalTo(userEmail).once();

      if (event.snapshot.value != null) {
        // Ensure the fetched data is a Map
        Map<dynamic, dynamic> driverData = event.snapshot.value as Map<dynamic, dynamic>;
        String empId = driverData.values.first['emp_id'] as String;  // Ensure type casting
        String fcmToken = driverData.values.first['fcmToken'] as String;

        // Now you have the empId and fcmToken, fetch schedules
        getRouteSchedulesForDriver(empId, fcmToken);
      }
    }
  }

  Future<void> getRouteSchedulesForDriver(String empId, String fcmToken) async {
    DatabaseReference schedulesRef = FirebaseDatabase.instance.ref('route_schedules');

    // Get all route schedules
    DatabaseEvent event = await schedulesRef.once();

    if (event.snapshot.value != null) {
      // Ensure the fetched data is a Map
      Map<dynamic, dynamic> schedules = event.snapshot.value as Map<dynamic, dynamic>;

      schedules.forEach((routeId, routeDays) {
        routeDays.forEach((day, schedule) {
          if (schedule['truck_driver'] == empId) {
            DateTime scheduleDate = DateTime.parse(schedule['date']);

            // Calculate 1 day before the schedule at 6:00 PM
            DateTime notificationDate = scheduleDate.subtract(Duration(days: 1)).add(Duration(hours: 18));

            if (DateTime.now().isBefore(notificationDate)) {
              // Schedule the notification
              scheduleNotification(schedule, fcmToken, notificationDate);
            }
          }
        });
      });
    }
  }

  Future<void> scheduleNotification(Map<dynamic, dynamic> schedule, String fcmToken, DateTime notificationDate) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', // Replace with your channel ID
      'channel_name', // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    var payload = {
      'title': 'Reminder: Upcoming Route Assignment',
      'body': 'Your route is scheduled for ${schedule['date']} at ${schedule['start_time']}. Please be prepared.',
    };

    // Schedule the notification using a delay based on the notificationDate
    Duration delay = notificationDate.difference(DateTime.now());

    Timer(delay, () {
      flutterLocalNotificationsPlugin.show(
        0,
        'Reminder: Upcoming Route Assignment',
        'Your route is scheduled for ${schedule['date']} at ${schedule['start_time']}.',
        notificationDetails,
        payload: jsonEncode(payload),
      );

      // Send FCM notification as well
      sendFCMNotification(fcmToken, payload);
    });
  }

  Future<void> sendFCMNotification(String fcmToken, Map<String, String> payload) async {
    String serverKey = 'YOUR_SERVER_KEY';  // Replace with your Firebase server key

    final postUrl = "https://fcm.googleapis.com/fcm/send";
    final data = {
      "notification": {
        "title": payload['title'],
        "body": payload['body'],
        "sound": "default",
      },
      "priority": "high",
      "to": fcmToken
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$serverKey'
    };

    final response = await http.post(Uri.parse(postUrl), body: jsonEncode(data), headers: headers);

    if (response.statusCode == 200) {
      print('FCM Notification sent successfully');
    } else {
      print('FCM Notification failed');
    }
  }

  Future<void> saveNotificationInFirebase(String empId, Map<String, String> payload) async {
    DatabaseReference notificationsRef = FirebaseDatabase.instance.ref('notifications/$empId');

    // Save the notification details
    await notificationsRef.push().set({
      'title': payload['title'],
      'body': payload['body'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
