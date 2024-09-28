import 'package:flutter/material.dart';
import 'package:greenroute/widgets/button_large.dart';

class TDLoginPage extends StatelessWidget {
  const TDLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login page",
      home: Scaffold(
        body: Column(
          children: [
            Image.asset("arrow_left.png"),
            const SizedBox(
              height: 20,
            ),
            Text("Sign In"),
            const SizedBox(
              height: 20,
            ),
            const Text("Username or Email"),
            const TextField(),
            const SizedBox(
              height: 20,
            ),
            const Text("Password"),
            const TextField(),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {}, child: BtnLarge(buttonText: "Sign In", onPressed: () {  },))
          ],
        ),
      ),
    );
  }
}
