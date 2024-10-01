import 'package:firebase_database/firebase_database.dart';

class LogBagsService {
  static Future<void> loadExistingLog({
    required String userEmail,
    required Function(Map<String, dynamic>, DatabaseReference) onLogFound,
  }) async {
    try {
      DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('garbage_logs');
      Query query = dbRef.orderByChild('user_email').equalTo(userEmail);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        // Extract the first log entry
        final logEntries = Map<String, dynamic>.from(snapshot.value as Map);
        final firstEntryKey = logEntries.keys.first;
        final logData = Map<String, dynamic>.from(logEntries[firstEntryKey]);
        DatabaseReference logRef = dbRef.child(firstEntryKey);

        onLogFound(logData, logRef); // Send the data and reference to UI
      } else {
        // Create a new log entry if none exists
        DatabaseReference newLogRef = dbRef.push();
        await newLogRef.set({
          'plastic_bags': 0,
          'paper_bags': 0,
          'food_bags': 0,
          'total_bags': 0,
          'user_email': userEmail,
        });
        onLogFound({
          'plastic_bags': 0,
          'paper_bags': 0,
          'food_bags': 0,
          'total_bags': 0,
        }, newLogRef);
      }
    } catch (e) {
      print('Error loading log: $e');
    }
  }

  static Future<void> updateLog({
    required DatabaseReference logRef,
    required int plasticBags,
    required int paperBags,
    required int foodBags,
    required int totalBags,
    required String userEmail,
  }) async {
    try {
      await logRef.update({
        'plastic_bags': plasticBags,
        'paper_bags': paperBags,
        'food_bags': foodBags,
        'total_bags': totalBags,
        'user_email': userEmail,
      });
      print('Data updated for user: $userEmail');
    } catch (e) {
      print('Error updating data: $e');
    }
  }
}
