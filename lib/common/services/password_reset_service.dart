// lib/services/password_reset_service.dart
import 'package:firebase_database/firebase_database.dart';

class PasswordResetService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> updatePassword(String email, String newPassword) async {
    try {
      final snapshot = await _dbRef.child('users').orderByChild('email').equalTo(email).once();
      if (snapshot.snapshot.exists) {
        var userKey = snapshot.snapshot.children.first.key;

        // Update the password for the user in the database
        await _dbRef.child('users/$userKey').update({
          'password': newPassword,
        });
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      throw Exception('Error updating password: $error');
    }
  }
}
