import 'package:flutter/material.dart';

class FuelPage extends StatelessWidget {
  const FuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action here
          },
        ),
        title: Text(
          'Fuel',
          style: TextStyle(
            color: Colors.green.shade800,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/qr.png'),
            SizedBox(height: 20,),
            // Fuel balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fuel Balance:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '10L', // dynamically update based on actual balance
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Previous fuel refill section
            Text(
              'Previous Fuel Refill:',
              style: TextStyle(
                fontSize: 25,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20),
            // Details of the previous fuel refill
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Fuel amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fuel Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '10L', // dynamically update based on actual amount
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Filling station
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filling Station:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Himbutana', // dynamically update based on actual station
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Date of refill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '12/08/2024', // dynamically update based on actual date
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            // "More.." button at the bottom
            GestureDetector(
              onTap: () {
                // Handle navigation to more details
              },
              child: Text(
                'More..',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
