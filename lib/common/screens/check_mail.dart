import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import '../../theme.dart'; // Assuming you have a theme file where AppColors and AppTextStyles are defined
import 'set_new_pwd.dart'; // Assuming you want to navigate to the SetNewPwd screen after verification

class CheckMail extends StatelessWidget {
  final String userEmail;

  const CheckMail({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Check E-mail",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigates back to the previous page
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: AppColors.primaryColor, // Use your defined primary color
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Check your E-mail",
                  style: AppTextStyles.topic, // Custom text style
                ),
                const SizedBox(height: 20),
                const Text(
                  "We sent a reset link to contact@dscoe.com. Enter the 5-digit code mentioned in the email.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.50,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => _buildCodeInputField(context)),
                ),
                const SizedBox(height: 30),
                Center(
                  child: BtnLarge(
                    buttonText: "Verify Code",
                    onPressed: () {
                      // Navigate to the SetNewPwd page after verification
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetNewPwd(userEmail: userEmail)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Resend email logic here
                    },
                    child: const Text(
                      "Haven’t got the email yet? Resend Email",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build individual input fields for the 6-digit verification code
  Widget _buildCodeInputField(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        maxLength: 1, // Limit input to 1 character
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '', // Hides character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Apply the border radius here
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Apply the border radius here
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Apply the border radius here
            borderSide: const BorderSide(
              color: AppColors.buttonColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
