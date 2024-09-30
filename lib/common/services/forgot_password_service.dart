import 'package:firebase_database/firebase_database.dart';

class ForgotPasswordService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();  // Firebase database reference

  // Method to check if the entered email exists in the Firebase Realtime Database
  Future<bool> checkEmailExists(String email) async {
    try {
      // Query to check if any user has the entered email
      final snapshot = await databaseReference
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      // If snapshot contains data, it means email exists
      return snapshot.snapshot.value != null;
    } catch (e) {
      // Handle any errors
      print('Error checking email: $e');
      return false;
    }
  }
}
