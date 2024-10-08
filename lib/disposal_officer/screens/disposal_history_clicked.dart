import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import '../../theme.dart';
import '../widgets/data_row.dart';

class DisposalHistoryClicked extends StatelessWidget {
  final String truckId;
  final String truckNumber;
  final String truckDriverName; // Changed from ID to name
  final String municipalCouncilName; // Changed from ID to name
  final String date;
  final String time;
  final String weight;

  const DisposalHistoryClicked({
    super.key,
    required this.truckId,
    required this.truckNumber,
    required this.truckDriverName, // Name instead of ID
    required this.municipalCouncilName, // Name instead of ID
    required this.date,
    required this.time,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackArrow(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("History", style: AppTextStyles.topic),
                  const SizedBox(height: 20),
                  Container(
                    decoration: ShapeDecoration(
                      color: Color(0x3F5EA417),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          DataRowWidget(description: "Truck ID :", data: truckId),
                          DataRowWidget(description: "Truck Number :", data: truckNumber),
                          DataRowWidget(description: "Truck Driver :", data: truckDriverName), // Display name
                          DataRowWidget(description: "Municipal Council :", data: municipalCouncilName), // Display name
                          DataRowWidget(description: "Date :", data: date),
                          DataRowWidget(description: "Time :", data: time),
                          DataRowWidget(description: "Weight :", data: "$weight kg"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
