import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import '../../theme.dart';

class DisposalHistoryClicked extends StatelessWidget {
  final String truckId;
  final String truckNumber;
  final String truckDriver;
  final String municipalCouncil;
  final String date;
  final String time;
  final String weight;

  const DisposalHistoryClicked({
    Key? key,
    required this.truckId,
    required this.truckNumber,
    required this.truckDriver,
    required this.municipalCouncil,
    required this.date,
    required this.time,
    required this.weight,
  }) : super(key: key);

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
                  const Text(
                    "History",
                    style: AppTextStyles.topic,
                  ),
                  const SizedBox(height: 40),
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
                          _dataRow("Truck ID :", truckId),
                          _dataRow("Truck Number :", truckNumber),
                          _dataRow("Truck Driver :", truckDriver),
                          _dataRow("Municipal Council :", municipalCouncil),
                          _dataRow("Date :", date),
                          _dataRow("Time :", time),
                          _dataRow("Weight :", "$weight kg"),
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

  Widget _dataRow(String description, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 153,
            child: Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            // Wrap the data text with Flexible to prevent overflow
            child: Text(
              data,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
              overflow: TextOverflow
                  .ellipsis, // If text is too long, it will be truncated with '...'
            ),
          ),
        ],
      ),
    );
  }
}
