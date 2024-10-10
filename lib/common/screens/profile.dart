import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/resident/widgets/bottom_nav_resident.dart';
import 'package:greenroute/disposal_officer/widgets/bottom_nav_do.dart';
import 'package:greenroute/truck_driver/widgets/bottom_nav_truck.dart';
import 'package:greenroute/theme.dart';
import '../widgets/new_button.dart';
import '../widgets/sidebar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userRole;
  String? userEmail;
  String? firstName;
  String? lastName;
  String? email;
  String?
      currentPassword; // To hold the user's current password from the database
  bool isEditing = false; // To toggle between view and edit mode

  // Text controllers to capture user input
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController =
      TextEditingController(); // Old password input
  final TextEditingController _newPasswordController =
      TextEditingController(); // New password input

  // Focus nodes to manage focus for the two password fields
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUserRoleAndEmail(); // Load the user role and email
  }

  @override
  void dispose() {
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  // Method to load user role and email from SharedPreferences
  Future<void> _loadUserRoleAndEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      userEmail = prefs.getString('user_email');
    });
    if (userEmail != null && userRole != null) {
      _fetchUserData(); // Fetch user data from the database
    }
  }

  // Method to fetch user data from Firebase based on user_role and user_email
  Future<void> _fetchUserData() async {
    String apiUrl = '';

    if (userRole == 'resident') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/resident.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'truck_driver') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'disposal_officer') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer.json?orderBy="email"&equalTo="$userEmail"';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.isNotEmpty) {
          var userData = data.values.first; // Fetch the first matching record
          setState(() {
            firstName = userData['first_name'];
            lastName = userData['last_name'];
            email = userData['email'];
            currentPassword = userData[
                'password']; // Store current password from the database

            // Set initial values in the TextEditingControllers
            _firstNameController.text = firstName!;
            _lastNameController.text = lastName!;
            _emailController.text = email!;
          });
        }
      } else {
        // Handle API error
        print('Failed to fetch user data');
      }
    } catch (e) {
      // Handle any errors during the API call
      print('Error fetching user data: $e');
    }
  }

  // Method to save updated user data back to Firebase
  Future<void> _saveProfile() async {
    String apiUrl = '';
    String? userId; // This will store the user's unique key

    // Determine the correct path based on the user role
    if (userRole == 'resident') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/resident.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'truck_driver') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'disposal_officer') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer.json?orderBy="email"&equalTo="$userEmail"';
    }

    try {
      // First, get the unique key for the user
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.isNotEmpty) {
          userId =
              data.keys.first; // Get the first key (unique ID) from the result
          var userUpdateUrl = "${apiUrl.split(".json")[0]}/$userId.json"; // Construct the full update URL with the key

          // Create the updated data map
          var updatedData = {
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'email': _emailController.text,
          };

          // Send the PATCH request with the correct URL including the user ID
          final updateResponse = await http.patch(Uri.parse(userUpdateUrl),
              body: jsonEncode(updatedData));

          if (updateResponse.statusCode == 200) {
            setState(() {
              firstName = _firstNameController.text;
              lastName = _lastNameController.text;
              email = _emailController.text;
              isEditing = false; // Switch back to view mode after saving
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
                // Success color
                behavior: SnackBarBehavior.floating,
                // Optional, to make it float
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to update!'),
                backgroundColor: Colors.red,
                // Error color
                behavior: SnackBarBehavior.floating,
                // Optional, to make it float
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
            print('Failed to update user data');
          }
        }
      } else {
        print('Failed to fetch user data');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Method to update the password
  Future<void> _savePassword() async {
    if (_oldPasswordController.text != currentPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Old password is incorrect!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New password cannot be empty!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    String apiUrl = '';
    String? userId;

    if (userRole == 'resident') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/resident.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'truck_driver') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json?orderBy="email"&equalTo="$userEmail"';
    } else if (userRole == 'disposal_officer') {
      apiUrl =
          'https://greenroute-7251d-default-rtdb.firebaseio.com/disposal_officer.json?orderBy="email"&equalTo="$userEmail"';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.isNotEmpty) {
          userId = data.keys.first;
          var userUpdateUrl = "${apiUrl.split(".json")[0]}/$userId.json";

          var updatedPasswordData = {
            'password': _newPasswordController.text,
          };

          final updateResponse = await http.patch(Uri.parse(userUpdateUrl),
              body: jsonEncode(updatedPasswordData));

          if (updateResponse.statusCode == 200) {
            // Clear the password fields after success
            _oldPasswordController.clear();
            _newPasswordController.clear();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password updated successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to update password!'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error saving password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus all text fields and dismiss the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // Allow scrolling when the keyboard appears
        drawer: const SideBar(),
        // Use the SideBar widget as the Drawer
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // Handle the keyboard
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: AppTextStyles.topic,
                            ),
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    // Dismiss the keyboard by unfocusing all input fields
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    Scaffold.of(context).openDrawer(); // Open the SideBar
                                  },

                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/profile.png',
                              height: 170,
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '$firstName $lastName',
                              style: const TextStyle(
                                color: Color(0xFF1A1E25),
                                fontSize: 24,
                                fontFamily: 'Hind',
                                fontWeight: FontWeight.w700,
                                height: 0.04,
                                letterSpacing: 0.31,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Editable fields when "Edit Profile" is clicked
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: isEditing,
                                controller: _firstNameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF2F3F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                enabled: isEditing,
                                controller: _lastNameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF2F3F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          enabled: isEditing,
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF2F3F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        BtnNew(
                          width: double.infinity,
                          height: 40,
                          buttonText:
                              isEditing ? 'Save Profile' : 'Edit Profile',
                          onPressed: () {
                            if (isEditing) {
                              _saveProfile(); // Save profile data
                            } else {
                              setState(() {
                                isEditing = true; // Enable editing
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 45),
                        const Text(
                          'RESET PASSWORD',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.40,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Wrap password TextFields with Focus widgets for better focus control
                        Focus(
                          focusNode: _oldPasswordFocusNode,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F3F3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: TextField(
                                controller: _oldPasswordController,
                                decoration: const InputDecoration(
                                  hintText: 'Old Password',
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Focus(
                          focusNode: _newPasswordFocusNode,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F3F3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: TextField(
                                controller: _newPasswordController,
                                decoration: const InputDecoration(
                                  hintText: 'New Password',
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BtnNew(
                              width: 116,
                              height: 36,
                              buttonText: 'Reset',
                              onPressed: () {
                                _savePassword(); // Call save password
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar:
            _buildBottomNavigationBar(), // Set the navigation bar here
      ),
    );
  }

  // Function to build the correct Bottom Navigation Bar based on user role
  Widget _buildBottomNavigationBar() {
    if (userRole == 'resident') {
      return const BottomNavR(current: 'profile');
    } else if (userRole == 'truck_driver') {
      return const BottomNavTD(current: 'profile');
    } else if (userRole == 'disposal_officer') {
      return const BottomNavDO(current: 'profile');
    } else {
      return const SizedBox.shrink(); // Return empty widget if no role matches
    }
  }
}
